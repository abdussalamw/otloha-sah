import importlib

from django.apps import apps
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.contenttypes.models import ContentType
from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.files_handler.forms import FilesForm, CSVUploadForm, DownloadFileFromUrlForm
from apps.files_handler.models import File
from apps.files_handler.tasks import execute
from apps.main.views_admin import AdminListView


class GenericResolverMixin:
    def check_next_url(self, next_url):
        if next_url is None:
            raise KeyError(str(_("key next must be included in request")))

    def check_process_name(self, process_name):
        if process_name is None:
            raise KeyError(str(_("key process_name must be included in request")))

    def check_process(self, process):
        if 'type' not in process:
            raise KeyError(str(_("key type must be included in file processor")))

        if process.get('type') == 'import_csv':
            if 'method' not in process:
                raise KeyError(str(_("key method must be included in file processor")))
            if 'form_class' not in process:
                raise KeyError(str(_("key form_class must be included in file processor")))
            if 'columns' not in process:
                raise KeyError(str(_("key columns must be included in file processor")))

    def get_model_instance(self, app_label, model_name):
        return apps.get_model(app_label, model_name)

    def get_file_processor(self, model, process_name):
        return model.FILE_PROCESSORS.get(process_name)

    def resolve_generic_module(self, request, app_label, model_name, next_url, object_id, process_name):
        self.check_next_url(next_url)
        model = self.get_model_instance(app_label, model_name)
        self.check_process_name(process_name)
        instance = get_object_or_404(model, pk=object_id)
        return model, instance, self.get_file_processor(model, process_name)


class FileListingView(LoginRequiredMixin, AdminListView):
    model = File
    title = _('Files')
    list_display = (
        ('id', _('Id')),
        ('file_name', _('File Name')),
        ('created_at', _('Created at')),
        ('status', _('Status')),
        ('actions', _('actions'))
    )
    ordering = ('id',)
    paginate_by = 100
    process_name = None
    app_label = None
    target_model = None
    target_model_id = None
    redirect_to = None
    model_class = None
    instance = None

    def get_queryset(self):
        if self.request.GET.get('next') is None:
            raise KeyError(str(_("key next must be included in request")))

        self.app_label = self.kwargs.get("app_label")
        self.target_model = self.kwargs.get("model")
        self.target_model_id = self.kwargs.get("object_id")
        self.process_name = self.kwargs.get("process_name")
        self.redirect_to = self.request.GET.get("next")
        self.model_class = apps.get_model(self.app_label, self.target_model)
        self.instance = get_object_or_404(self.model_class, pk=self.target_model_id)
        content_type = ContentType.objects.get_for_model(self.instance)
        queryset = super().get_queryset().filter(content_type=content_type, object_id=self.target_model_id,
                                                 process_name=self.process_name)
        if self.filterset_class:
            queryset = self.filterset_class(self.request.GET, queryset).qs
        return queryset

    def load_process(self, obj):
        app_label = self.kwargs['app_label']
        model = self.kwargs['model']
        object_id = self.kwargs['object_id']
        url = reverse('admin:files:process', args=[app_label, model, object_id, obj.pk])
        return mark_safe('<td><a href="{}" disabled=True><i class="fa fa-play"></i></a></td>'.format(url))

    def load_is_processed(self, obj):
        return mark_safe(
            '<td><span class="badge bg-{}">{}</span></td>'.format('primary' if obj.is_processed else 'danger',
                                                                  'Yes' if obj.is_processed else 'No'))

    def load_file_name(self, obj):
        details = reverse("admin:files:csv:details", args=[
            self.app_label,
            self.target_model,
            self.target_model_id,
            obj.id
        ])
        print('file', obj.file)
        return mark_safe(
            '<td class="main-cell"><a href="{}">{}</a></td>'.format(
                "{}?next={}".format(details, self.redirect_to),
                obj.file_name if obj.file is not None else '{} ({})'.format(obj.file_name, _("Downloading...")))
        )

    def load_created_at(self, obj):
        return mark_safe('<td class="main-cell">{}</td>'.format(obj.created_at))

    def load_actions(self, obj):
        process_url = reverse("admin:files:process", args=[
            self.app_label,
            self.target_model,
            self.target_model_id,
            self.process_name,
            obj.id])
        return mark_safe(
            '<td class="td--nowrap">' +
            '<a href="{}" class="btn btn-sm btn-info mr-1" title="{}"><i class="fa fa-play"></i></a>'
            .format(
                "{}?next={}".format(process_url, self.redirect_to) if obj.file else '#',
                _("Process File")) +
            '<a href="{}?next={}" class="btn btn-sm btn-danger" title="{}"><i class="fa fa-trash"></i></a>'
            .format(
                reverse("admin:softdelete:single-delete", args=["files_handler", "File", obj.id]),
                "{}?next={}".format(self.request.path, self.redirect_to),
                _("Delete")) +
            '</td>')

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": self.model_class._meta.verbose_name_plural},
            {"name": self.instance, "url": self.redirect_to},
            {"name": self.title}
        ]

    def get_actions(self):
        return mark_safe(
            "<a href='{}?next={}' class='btn btn-sm btn-primary mx-2'>"
            "<i class='fas fa-plus'></i>{}</a>".format(
                reverse("admin:files:download-from-url", args=[
                    self.app_label, self.target_model, self.target_model_id, self.process_name,
                ]),
                "{}?next={}".format(self.request.path, self.redirect_to),
                _("Download From Url")) +
            "<a href='{}?next={}' class='btn btn-sm btn-primary'>"
            "<i class='fas fa-plus'></i>{}</a>".format(
                reverse("admin:files:create", args=[
                    self.app_label, self.target_model, self.target_model_id, self.process_name,
                ]),
                "{}?next={}".format(self.request.path, self.redirect_to),
                _("Add New File"))
        )


class CreateFileView(LoginRequiredMixin, GenericResolverMixin, View):
    def get_import_csv_response(self, instance, request, processor):
        if request.method == 'POST':
            return CSVUploadForm(request.POST, request.FILES, model=instance, processor=processor), _("Upload New CSV")
        return CSVUploadForm(model=instance, processor=processor), _("Upload New CSV")

    def get_import_zip_file_response(self, instance, request, processor):
        if request.method == 'POST':
            return FilesForm(request.POST, request.FILES, model=instance, processor=processor), _("Upload New ZIP File")
        return FilesForm(model=instance, processor=processor), _("Upload New ZIP File")

    def get_response_context(self, model_class, process_name, instance, request):
        process = model_class.FILE_PROCESSORS.get(process_name)
        self.check_process(process)
        if process.get('type') == 'import_csv':
            form, title = self.get_import_csv_response(instance, request, process_name)
        else:
            form, title = self.get_import_zip_file_response(instance, request, process_name)

        return form, title

    def get(self, request, app_label, model, object_id, process_name, *args, **kwargs):
        model, instance, processor = self.resolve_generic_module(
            request=request,
            app_label=app_label,
            model_name=model,
            next_url=request.GET.get("next"),
            object_id=object_id,
            process_name=process_name)

        form, title = self.get_response_context(model, process_name, instance, request)

        return render(request, 'files_handler/form.html', {
            'next': request.GET.get('next'),
            'form': form,
            'title': title
        })

    def post(self, request, app_label, model, object_id, process_name, *args, **kwargs):
        model, instance, processor = self.resolve_generic_module(
            request=request,
            app_label=app_label,
            model_name=model,
            next_url=request.GET.get("next"),
            object_id=object_id,
            process_name=process_name)

        form, title = self.get_response_context(model, process_name, instance, request)

        if form.is_valid():
            if processor.get('type') == 'import_csv':
                form.save()
            else:
                for file in request.FILES.getlist('file'):
                    File.objects.create(
                        process_type=processor.get('type'),
                        process_name=process_name,
                        file_name=file._name,
                        file=file,
                        content_object=instance)

            messages.success(request, _("Files is uploaded successfully"))
            return redirect(request.GET.get('next'))

        return render(request, 'files_handler/form.html', {
            'next': request.GET.get('next'),
            'form': form,
            'title': title
        })


class DownloadFileFromUrlView(LoginRequiredMixin, GenericResolverMixin, View):
    def get(self, request, app_label, model, object_id, process_name, *args, **kwargs):
        model, instance, processor = self.resolve_generic_module(
            request=request,
            app_label=app_label,
            model_name=model,
            next_url=request.GET.get("next"),
            object_id=object_id,
            process_name=process_name)

        return render(request, 'files_handler/form.html', {
            'next': request.GET.get('next'),
            'form': DownloadFileFromUrlForm(model=instance, processor=processor),
            'title': _("Download File From URL")
        })

    def post(self, request, app_label, model, object_id, process_name, *args, **kwargs):
        model, instance, processor = self.resolve_generic_module(
            request=request,
            app_label=app_label,
            model_name=model,
            next_url=request.GET.get("next"),
            object_id=object_id,
            process_name=process_name)

        form = DownloadFileFromUrlForm(request.POST, model=instance, processor=process_name)
        if form.is_valid():
            form.save(instance)
            messages.success(request, _("Files is being downloaded"))
            return redirect(request.GET.get('next'))
        return render(request, 'files_handler/form.html', {
            'next': request.GET.get('next'),
            'form': form,
            'title': _("Download File From URL")
        })


class FileDetailsView(LoginRequiredMixin, View):
    def get(self, request, app_label, model, object_id, csv_id, *args, **kwargs):
        if request.GET.get('next') is None:
            raise KeyError(str(_("key next must be included in request")))

        model_class = apps.get_model(app_label, model)
        instance = get_object_or_404(model_class, pk=object_id)

        csv = get_object_or_404(File, pk=csv_id)
        return render(request, 'files_handler/csv/details.html', {
            'model_class': model,
            'instance': instance,
            'csv': csv,
            "next": request.GET.get('next'),
            'title': _("CSV Details")
        })


class ProcessFileView(LoginRequiredMixin, GenericResolverMixin, View):
    def get_processor_form(self, model, processor, *args, **kwargs):
        form_class = processor.get('form_class')
        split_form_name = form_class.split('.')
        class_name = split_form_name[-1:][0]
        module_name = split_form_name[:-1]
        form_class = getattr(importlib.import_module('.'.join(module_name)), class_name)
        return form_class(processor=processor, *args, **kwargs)

    def get_form(self, model, file_object, processor, *args, **kwargs):
        if processor.get('type') == 'import_csv':
            form_class = self.get_processor_form(
                model, processor, file_object=file_object, *args, **kwargs)
        else:
            form_class = None
        return form_class

    def get_template_response(self, request, model, instance, form, app_label, object_id, file_object):
        return render(request, 'files_handler/confirm_process.html', {
            "next": request.GET.get('next'),
            'title': _('Confirm Process File'),
            'instance': instance,
            'form': form,
            "app_label": app_label,
            "model": model,
            "object_id": object_id,
            "breadcrumb": [
                {"name": _("Home"), "url": reverse('admin:main:home')},
                {"name": model._meta.verbose_name_plural},
                {"name": instance, "url": request.GET.get('next')},
                {"name": _("Files"), "url": reverse("admin:files:csv:listing", args=[
                    app_label, model, object_id
                ])},
                # {"name": file_object, "url": reverse("admin:files:details", args=[
                #     app_label, model, object_id, file_object.id
                # ])},
            ],
        })

    def get(self, request, app_label, model, object_id, process_name, file_id, *args, **kwargs):
        model, instance, processor = self.resolve_generic_module(
            request=request,
            app_label=app_label,
            model_name=model,
            next_url=request.GET.get("next"),
            object_id=object_id,
            process_name=process_name)

        file_object = get_object_or_404(File, pk=file_id)

        return self.get_template_response(
            request=request,
            model=model,
            instance=instance,
            form=self.get_form(processor=processor, model=instance, file_object=file_object),
            app_label=app_label,
            object_id=object_id,
            file_object=file_object)

    def post(self, request, app_label, model, object_id, process_name, file_id, *args, **kwargs):
        model, instance, processor = self.resolve_generic_module(
            request=request,
            app_label=app_label,
            model_name=model,
            next_url=request.GET.get("next"),
            object_id=object_id,
            process_name=process_name)

        file_object = get_object_or_404(File, pk=file_id)
        form = self.get_form(
            data=request.POST,
            files=request.FILES,
            model=instance,
            file_object=file_object,
            processor=processor)

        if form:
            if form.is_valid():
                form.save()
            else:
                return self.get_template_response(
                    request=request,
                    model=model,
                    instance=instance,
                    form=form,
                    app_label=app_label,
                    object_id=object_id,
                    file_object=file_object)

        file_object.status = file_object.STATUS_PROCESSING
        file_object.save()
        execute.delay(file_object.pk, process_name, processor.get('method'))
        messages.success(request, _("File is Being Processed"))
        return redirect(request.GET.get("next"))
