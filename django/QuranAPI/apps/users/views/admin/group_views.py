from django.contrib.auth.models import Group
from django.shortcuts import render, redirect
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext_lazy as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.users.forms.admin.group_forms import GroupForm


class AdminGroupListingView(AdminListView):
    model = Group
    title = _('Groups')
    main_column = 'Name'

    list_display = (
        ('id', _('id')),
        ('name', _('name')),
        ('actions', _('actions')),
    )

    def get_queryset(self):
        return Group.objects.all()

    def get_actions(self):
        return mark_safe('<a href="{}" class="btn btn--primary btn--text btn--with-icon">'
                         '<i class="fa fa-plus"></i>{}</a>'.format(reverse("admin:groups:create"),
                                                                   _("Add New group")))

    def load_actions(self, obj):
        edit = reverse('admin:group:edit', args=[obj.id])
        return mark_safe("".join([
            '<td class="td--action">'
            '<a href="{}" title="{}" class="gray-s"><i class="fa fa-edit"></i></a>'.format(edit, _('edit')),
            '</td>'
        ]))


class AdminGroupCreateOrUpdate(View):
    def get(self, request, *args, **kwargs):
        if kwargs.get('pk', None):
            group = Group.objects.get(pk=kwargs['pk'])
            form = GroupForm(instance=group)
        else:
            form = GroupForm
        return render(request, 'admin/groups/form.html', {
            'form': form,
            "back_link": reverse('admin:groups:listing')
        })

    def post(self, request, *args, **kwargs):
        if kwargs.get('pk', None):
            course = Group.objects.get(pk=kwargs['pk'])
            form = GroupForm(request.POST, instance=course)
        else:
            form = GroupForm(data=self.request.POST)
        if form.is_valid():
            form.save()
        return redirect(reverse('admin:groups:listing'))


class AdminGroupDetailsView(View):
    pass
