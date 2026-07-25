from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.contrib.auth.models import Group
from django.http import JsonResponse
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View
from django.views.generic import DetailView
from dynamic_listing.views import DynamicGridView, BulkActionMixin

from apps.users.filters import GroupFilter
from apps.users.forms import GroupForm
from apps.users.forms.group import GroupAdminForm
from apps.users.views.views_admin.listing_factories import AdminDynamicTableFactory


class GroupListingView(LoginRequiredMixin, PermissionRequiredMixin, DynamicGridView):
    permission_required = "auth.view_group"
    model = Group
    filterset_class = GroupFilter
    item_template_name = "groups/listing/_grid_item.html"
    listing_actions = "groups/listing/_actions.html"
    title = _("Roles")

    def get_breadcrumb(self):
        return [
            {"title": _("Home"), "url": reverse("admin:main:home")},
            {"title": _("Roles")},
        ]


class GroupDetailsView(LoginRequiredMixin, PermissionRequiredMixin, DetailView):
    permission_required = "auth.view_group"
    model = Group
    template_name = "groups/details/index.html"

    def get_breadcrumb(self):
        return [
            {"title": _("Home"), "url": reverse("admin:main:home")},
            {"title": _("Roles"), "url": reverse("admin:groups:listing")},
            {"title": self.object.name},
        ]

    def get_title(self):
        return self.object.name

    def get_context_data(self, **kwargs):
        context = super(GroupDetailsView, self).get_context_data(**kwargs)
        context["breadcrumb"] = self.get_breadcrumb()
        context["title"] = self.get_title()
        context['actions'] = "groups/details/_actions.html"
        users = AdminDynamicTableFactory(
            request=self.request,
            queryset=self.object.user_set.all(),
        )
        users.extra_context['form'] = GroupAdminForm(instance=self.object)
        users.extra_context['group'] = self.object
        users.extra_context['csrf_token'] = self.request.COOKIES['csrftoken']
        context["users"] = users
        return context


class GroupCreateOrUpdateView(LoginRequiredMixin, PermissionRequiredMixin, View):

    def __init__(self, *args, **kwargs):
        super(GroupCreateOrUpdateView, self).__init__(*args, **kwargs)
        self.form = None

    def get_permission_required(self):
        return ("auth.change_group",) if self.kwargs.get("pk", None) else ("auth.add_group",)

    def get_breadcrumb(self):
        breadcrumb = [
            {"title": _("Home"), "url": reverse("admin:main:home")},
            {"title": _("Roles"), "url": reverse("admin:groups:listing")},
        ]
        if self.kwargs.get("pk", None):
            breadcrumb.append({"title": _("Edit {role_name}").format(role_name=f"{self.form.instance.name}")})
        else:
            breadcrumb.append({"title": _("Create")})

        return breadcrumb

    def get_template_response(self):
        return render(self.request, "groups/form/index.html", {
            "breadcrumb": self.get_breadcrumb(),
            "form": self.form,
            "title": _("Edit Role") if self.kwargs.get("pk", None) else _("Create Role"),
        })

    def add_message(self):
        message = _("Role updated successfully") if self.kwargs.get("pk", None) else _("Role created successfully")
        messages.success(self.request, message)

    def get(self, request, *args, **kwargs):
        if group_id := kwargs.get("pk", None):
            instance = get_object_or_404(Group, pk=group_id)
            self.form = GroupForm(instance=instance)
        else:
            self.form = GroupForm()

        return self.get_template_response()

    def post(self, request, *args, **kwargs):

        if group_id := kwargs.get("pk", None):
            instance = get_object_or_404(Group, pk=group_id)
            self.form = GroupForm(request.POST, instance=instance)
        else:
            self.form = GroupForm(request.POST)

        if self.form.is_valid():
            instance = self.form.save()
            self.add_message()
            return redirect(reverse("admin:groups:details", args=[instance.pk]))

        return self.get_template_response()


class DeleteGroupView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = "auth.delete_group"

    def post(self, request, pk, *args, **kwargs):
        group = get_object_or_404(Group, pk=pk)
        group.delete()
        messages.success(request, _("Role deleted successfully"))
        return redirect(reverse("admin:groups:listing"))


class GrantGroupAccessView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = "auth.change_group"

    def post(self, request, pk, *args, **kwargs):
        group = get_object_or_404(Group, pk=pk)
        form = GroupAdminForm(request.POST, instance=group)
        if form.is_valid():
            form.save()
            messages.success(request, _("Access granted successfully"))

        return redirect(reverse("admin:groups:details", args=[group.pk]))


class RevokeGroupAccessView(BulkActionMixin, LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = "auth.change_group"

    def post(self, request, pk, *args, **kwargs):
        message = _("Access revoked successfully")
        status = True
        group = get_object_or_404(Group, pk=pk)
        queryset = group.user_set

        if user_id := kwargs.get('user_id', None):
            queryset = queryset.filter(pk=user_id)
            if not queryset.exists():
                message = _("Invalid user id")
                status = False
        else:
            input_type, value = self.get_actions_type_and_value(request.POST)
            if input_type == 'selected':
                queryset = queryset.filter(id__in=value)
                queryset_ids = queryset.values_list('id', flat=True)
                if not all([int(uid) in queryset_ids for uid in value]) or not queryset.exists():
                    message = _("Invalid user ids")
                    status = False
            elif input_type == 'queryset':
                queryset = GroupFilter(data=value, queryset=queryset.all()).qs
            elif input_type == 'none':
                queryset = queryset.all()
            else:
                message = _("No data provided")
                status = False

        if status:
            for user in queryset:
                user.groups.remove(group)

        return JsonResponse({"message": message}, status=200 if status else 422)
