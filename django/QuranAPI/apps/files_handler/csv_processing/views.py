import importlib

from django.apps import apps
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.contenttypes.models import ContentType
from django.shortcuts import get_object_or_404, render, redirect
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.files_handler.csv_processing.forms import CSVUploadForm
from apps.files_handler.csv_processing.process_csv import execute
from apps.files_handler.models import File
from apps.main.views_admin import AdminListView


class CSVListingView(LoginRequiredMixin, AdminListView):
    model = File
    title = _('CSV Uploads')
    list_display = (
        ('id', _('Id')),
        ('file_name', _('File Name')),
        ('created_at', _('Created at')),
        ('status', _('Status')),
        ('actions', _('actions'))
    )
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
        self.redirect_to = self.request.GET.get("next")
        self.model_class = apps.get_model(self.app_label, self.target_model)
        self.instance = get_object_or_404(self.model_class, pk=self.target_model_id)
        content_type = ContentType.objects.get_for_model(self.instance)
        queryset = super().get_queryset().filter(content_type=content_type, object_id=self.target_model_id)
        if self.filterset_class:
            queryset = self.filterset_class(self.request.GET, queryset).qs
        return queryset

    def load_file_name(self, obj):
        details = reverse("admin:files:csv:details", args=[
            self.app_label,
            self.target_model,
            self.target_model_id,
            obj.id
        ])
        return mark_safe(
            '<td class="main-cell"><a href="{}">{}</a></td>'.format(
                "{}?next={}".format(details, self.redirect_to), obj.file_name)
        )

    def load_created_at(self, obj):
        return mark_safe('<td class="main-cell">{}</td>'.format(obj.created_at))

    def get_actions(self):
        pass
        # return mark_safe(
        #     '<a href="{}" class="btn btn-primary btn-block"><i class="fas fa-plus"></i>{}</a>'
        #         .format(reverse("admin:files:csv:create", args=[self.kwargs['book_id']]),
        #                 _("Add New Book CSV Uploads")))

    def load_actions(self, obj):
        process_url = reverse("admin:files:csv:process", args=[
            self.app_label,
            self.target_model,
            self.target_model_id,
            obj.id])
        return mark_safe(
            '<td class="td--nowrap">' +
            '<a href="{}" class="btn btn-sm btn-info mr-1" title="{}"><i class="fa fa-play"></i></a>'
            .format("{}?next={}".format(process_url, self.redirect_to), _("Process File")) +
            '<a href="{}" class="btn btn-sm btn-danger" title="{}"><i class="fa fa-trash"></i></a>'
            .format("#", _("Delete")) +
            '</td>')

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": self.model_class._meta.verbose_name_plural},
            {"name": self.instance, "url": self.redirect_to},
            {"name": self.title}
        ]


class CSVUploadView(LoginRequiredMixin, View):
    def get(self, request, app_label, model, object_id, *args, **kwargs):
        if request.GET.get('next') is None:
            raise KeyError(str(_("key next must be included in request")))

        model = apps.get_model(app_label, model)
        instance = get_object_or_404(model, pk=object_id)

        form = CSVUploadForm(model=instance)
        return render(request, 'files_handler/csv/upload_form.html', {
            "next": request.GET.get('next'),
            'form': form,
            'title': _("Upload New CSV"),
            "model": instance
        })

    def post(self, request, app_label, model, object_id, *args, **kwargs):
        if request.GET.get('next') is None:
            raise KeyError(str(_("key next must be included in request")))

        redirect_to = request.GET.get('next')
        model_class = apps.get_model(app_label, model)
        instance = get_object_or_404(model_class, pk=object_id)
        form = CSVUploadForm(data=request.POST, files=request.FILES, model=instance)
        if form.is_valid():
            instance = form.save()
            messages.success(request, _("CSV Uploaded Successfully"))
            return redirect(redirect_to)

        return render(request, 'quran/book/csv/upload_form.html', {
            "next": redirect_to,
            'form': form,
            'title': _("Upload New CSV"),
            "model": instance
        })


class CSVDetailsView(LoginRequiredMixin, View):
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


class CSVProcessView(LoginRequiredMixin, View):
    def get_form(self, model, *args, **kwargs):
        form_name = model.csv_form
        split_form_name = form_name.split('.')
        class_name = split_form_name[-1:][0]
        module_name = split_form_name[:-1]
        form_class = getattr(importlib.import_module('.'.join(module_name)), class_name)
        return form_class(*args, **kwargs)

    def get(self, request, app_label, model, object_id, csv_id, *args, **kwargs):
        if request.GET.get('next') is None:
            raise KeyError(str(_("key next must be included in request")))

        model_class = apps.get_model(app_label, model)
        instance = get_object_or_404(model_class, pk=object_id)

        csv = get_object_or_404(File, pk=csv_id)
        form = self.get_form(model=instance, csv=csv)
        return render(request, 'files_handler/csv/process_file.html', {
            "next": request.GET.get('next'),
            "breadcrumb": [
                {"name": _("Home"), "url": reverse('admin:main:home')},
                {"name": model_class._meta.verbose_name_plural},
                {"name": instance, "url": request.GET.get('next')},
                {"name": _("CSV Files"), "url": reverse("admin:files:csv:listing", args=[
                    app_label, model, object_id
                ])},
                {"name": csv.file_name, "url": reverse("admin:files:csv:details", args=[
                    app_label, model, object_id, csv_id
                ])},
            ],

            "app_label": app_label,
            "model": model,
            "object_id": object_id,
            'form': form,
            "instance": instance,
            "book_csv": csv,
            "title": _("Prepare CSV for Processing")
        })

    def post(self, request, app_label, model, object_id, csv_id, *args, **kwargs):
        if request.GET.get('next') is None:
            raise KeyError(str(_("key next must be included in request")))
        model_class = apps.get_model(app_label, model)
        instance = get_object_or_404(model_class, pk=object_id)

        csv = get_object_or_404(File, pk=csv_id)

        form = self.get_form(data=request.POST, files=request.FILES, model=instance, csv=csv)

        if form.is_valid():
            instance = form.save()
            # Mark File as Processing
            csv.status = csv.STATUS_PROCESSING
            csv.save()
            execute.delay(csv.pk)
            messages.success(request, _("CSV is Being Processed"))
            return redirect(request.POST.get('next'))

        return render(request, 'files_handler/csv/process_file.html', {
            "next": request.POST.get('next'),
            "breadcrumb": [
                {"name": _("Home"), "url": reverse('admin:main:home')},
                {"name": model_class._meta.verbose_name_plural},
                {"name": instance, "url": request.GET.get('next')},
                {"name": _("CSV Files"), "url": reverse("admin:files:csv:listing", args=[
                    app_label, model, object_id
                ])},
                {"name": csv.file_name, "url": reverse("admin:files:csv:details", args=[
                    app_label, model, object_id, csv_id
                ])},
            ],
            "app_label": app_label,
            "model": model,
            "object_id": object_id,
            'form': form,
            "instance": instance,
            "book_csv": csv,
            "title": _("Prepare CSV for Processing")
        })
