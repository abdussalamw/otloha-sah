import pandas as pd
from django import forms
from django.core.exceptions import ValidationError
from django.utils.translation import gettext as _

from apps.files_handler.models import File


def get_columns_names(file):
    data = pd.read_csv(file)
    columns = {col: i for i, col in enumerate(data.columns)}
    return columns


class CSVUploadForm(forms.ModelForm):
    error_messages = {
        "invalid_file": _('file must be of type csv')
    }

    class Meta:
        model = File
        fields = ['file']

    def __init__(self, *args, **kwargs):
        self.target_model = kwargs.pop('model')
        self.processor = kwargs.pop('processor')
        super(CSVUploadForm, self).__init__(*args, **kwargs)

        if not self.instance.pk:
            self.instance.columns = self.target_model.FILE_PROCESSORS.get(self.processor)

    def clean_file(self):
        file = self.cleaned_data['file']
        if file.name.split('.')[1] != 'csv':
            raise ValidationError(self.error_messages['invalid_file'],
                                  code="invalid_file",
                                  params={"file": File._meta.get_field('file').verbose_name})
        return file

    def save(self, commit=True):
        instance = super(CSVUploadForm, self).save(commit=False)
        instance.content_object = self.target_model
        instance.file_name = self.instance.file.name
        instance.user_choice_columns = get_columns_names(instance.file)
        if commit:
            instance.save()
        return instance


class ProcessCSVForm(forms.Form):
    def __init__(self, file_object, processor, *args, **kwargs):
        self.processor = processor
        self.file_object = file_object
        print(self.file_object.__dict__)
        self.user_choices = [(value, key) for key, value in file_object.user_choice_columns.items()]
        super(ProcessCSVForm, self).__init__(*args, **kwargs)
        for field in list(self.fields.keys()):
            self.fields[field].choices = self.user_choices
        if all([value for key, value in self.file_object.columns.items()]):
            for field in list(self.fields.keys()):
                self.fields[field].initial = self.file_object.columns[field]

    def clean(self):
        cleaned_data = self.cleaned_data

        rev_dict = {}
        for key, value in cleaned_data.items():
            rev_dict.setdefault(value, set()).add(key)
        duplicated_values_keys = [values for key, values in rev_dict.items() if len(values) > 1]
        flat_duplicated_values_keys = [item for sublist in duplicated_values_keys for item in sublist]
        if len(flat_duplicated_values_keys) > 0:
            raise ValidationError({
                field: ValidationError(
                    _('You selected this value for another field.'),
                    code="duplicated_value") for field in flat_duplicated_values_keys
            })

        return cleaned_data

    def save(self, *args, **kwargs):
        instance = self.file_object
        for field, value in self.cleaned_data.items():
            instance.columns[field] = int(value)
        instance.save()
