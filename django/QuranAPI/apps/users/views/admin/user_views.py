from django.contrib.auth.mixins import LoginRequiredMixin
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext_lazy as _
from django.views import View
from django.views.generic import DetailView

from apps.main.views_admin import AdminListView
from apps.users.filters import UsersAdminFilter
from apps.users.models import User


class AdminUserStuffListingView(AdminListView):
    model = User
    main_column = 'username'
    title = _("Staff")
    filterset_class = UsersAdminFilter
    context_object_name = 'filter'
    ordering = ["-id"]

    list_display = (
        ('id', _('Id')),
        ('username', _('Username')),
        ('email', _('Email')),
        ('phone', _('Phone')),
        ('is_active', _('Is Active')),
        ('groups', _('Groups')),
        ('actions', _('Actions')),
    )

    def load_title(self, obj):
        return mark_safe(
            '<td class="main-cell"><a href="{}">{}</a></td>'.format(obj.get_profile_url, obj.username))

    def load_groups(self, obj):
        return mark_safe(
            '<td>{}</td>'.format(",".join(list(obj.groups.all().values_list('name', flat=True))))
        )

    def get_queryset(self):
        queryset = super(AdminUserStuffListingView, self).get_queryset()
        return queryset.filter(is_staff=True)

    def get_actions(self):
        return mark_safe('<a href="{}" class="btn btn--primary btn--text btn--with-icon">'
                         '<i class="fa fa-plus"></i>{}</a>'.format(reverse("admin:users:create"),
                                                                   _("Add New User")))

    def load_actions(self, obj):
        edit = obj.get_profile_url
        return mark_safe("".join([
            '<td class="td--action">'
            '<a href="{}" title="{}" class="gray-s"><i class="fa fa-edit"></i></a>'.format(edit, _('edit')),
            '</td>'
        ]))

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context

    def get_create_link(self):
        return reverse('admin:users:create')

    def load_parent(self, obj):
        if obj.parent is None:
            return mark_safe('<td>No Parent</td>')
        else:
            parent_detail = reverse('admin:users:details', args=[obj.parent.id])
            return mark_safe('<td><a href="{}" ></a></td>'.format(parent_detail))


class AdminUserAccountsListingView(AdminListView):
    model = User
    main_column = 'username'
    title = _("All Users")
    filterset_class = UsersAdminFilter
    context_object_name = 'filter'

    list_display = (
        ('id', _('id')),
        ('username', _('username')),
        ('email', _('email')),
        ('phone', _('phone')),
        ('actions', _('actions')),

    )

    def load_title(self, obj):
        return mark_safe(
            '<td class="main-cell"><a href="{}">{}</a></td>'.format(obj.get_admin_url, obj.username))

    def get_queryset(self):
        queryset = super(AdminUserAccountsListingView, self).get_queryset()
        return queryset.filter(is_staff=False)

    def load_actions(self, obj):
        edit = obj.get_profile_url
        return mark_safe("".join([
            '<td class="td--action">'
            '<a href="{}" title="{}" class="gray-s"><i class="fa fa-edit"></i></a>'.format(edit, _('edit')),
            '</td>'
        ]))

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context

    def get_create_link(self):
        return reverse('admin:users:create')

    def load_parent(self, obj):
        if obj.parent is None:
            return mark_safe('<td>No Parent</td>')
        else:
            parent_detail = reverse('admin:users:details', args=[obj.parent.id])
            return mark_safe('<td><a href="{}" ></a></td>'.format(parent_detail))

# this BS logical
class AdminStudentsAccountsListingView(AdminListView):
    model = User
    main_column = 'username'
    title = _("All Students")
    filterset_class = UsersAdminFilter
    context_object_name = 'filter'

    list_display = (
        ('id', _('id')),
        ('username', _('username')),
        ('email', _('email')),
        ('phone', _('phone')),
        ('actions', _('actions')),

    )

    def load_title(self, obj):
        return mark_safe(
            '<td class="main-cell"><a href="{}">{}</a></td>'.format(obj.get_admin_url, obj.username))

    def get_queryset(self):
        queryset = super(AdminStudentsAccountsListingView, self).get_queryset()
        return queryset.filter(is_a_teacher=False)

    def load_actions(self, obj):
        edit = obj.get_profile_url
        return mark_safe("".join([
            '<td class="td--action">'
            '<a href="{}" title="{}" class="gray-s"><i class="fa fa-edit"></i></a>'.format(edit, _('edit')),
            '</td>'
        ]))

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


class AdminUserDetailsView(DetailView):
    model = User
    template_name = 'admin/users/details.html'


class AdminUserCreateOrUpdateView(LoginRequiredMixin, View):
    pass

    # def get(self, request, *args, **kwargs):
    #     if kwargs.get('user_id', None):
    #         user = get_object_or_404(User, pk=kwargs['user_id'])
    #         form = AdminUserEditForm(instance=user)
    #         if form.is_valid():
    #             form.save()
    #
    #         return render(request, 'admin/users/form.html', {
    #             'form': form,
    #         })
    #
    # def post(self, request, *args, **kwargs):
    #     if kwargs.get('user_id', None):
    #         user = get_object_or_404(User, pk=kwargs['user_id'])
    #         form = AdminUserEditForm(request.POST, instance=user)
    #         if form.is_valid():
    #             form.save()
    #
    #         return redirect(reverse('admin:users:stuff-listing'))
    #     else:
    #         form = AdminUserCreateForm(request.POST)
    #         if form.is_valid():
    #             form.save()
    #             last_user = User.objects.last()
    #             last_user.is_staff = True
    #             last_user.save()
    #             return redirect(reverse('admin:users:stuff-listing'))
    #
    #     return render(request, 'admin/users/form.html', {
    #         'form': form,
    #     }, None, status=422)


class UserProfileView(DetailView):
    pass
