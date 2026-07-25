from django import forms
from django.contrib.admin.widgets import FilteredSelectMultiple
from django.contrib.auth.models import Group, Permission


class GroupForm(forms.ModelForm):
    permissions = forms.ModelMultipleChoiceField(queryset=Permission.objects.all(),
                                                 widget=FilteredSelectMultiple("permissions", True))

    class Meta:
        model = Group
        fields = ('name', 'permissions')

    class Media:
        css = {
            'all': ['admin/css/widgets.css',
                    'css/uid-manage-form.css'],
        }
        # Adding this javascript is crucial
        js = ['/admin/jsi18n/']

    def __init__(self, *args, **kwargs):
        if kwargs.get('instance'):
            # We get the 'initial' keyword argument or initialize it
            # as a dict if it didn't exist.
            initial = kwargs.setdefault('initial', {})
            # The widget for a ModelMultipleChoiceField expects
            # a list of primary key for the selected data.
            initial['permissions'] = [t.pk for t in kwargs['instance'].permissions.all()]
        super().__init__(*args, **kwargs)
        self.fields['name'].required = True
        self.fields['permissions'].required = True
