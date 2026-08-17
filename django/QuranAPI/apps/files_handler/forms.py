import pandas as pd
from django import forms
from django.core.exceptions import ValidationError
from django.utils.translation import gettext as _

from apps.files_handler.models import File
from apps.files_handler.tasks import download_from_url


def get_columns_names(file):
    data = pd.read_csv(file)
    columns = {col: i for i, col in enumerate(data.columns)}
    return columns


class FilesForm(forms.ModelForm):
    error_messages = {
        "invalid_csv_file": _('file must be of type csv')
    }

    class Meta:
        model = File
        fields = ['file']
        widgets = {'file': forms.ClearableFileInput()}

    def __init__(self, *args, **kwargs):
        self.target_model = kwargs.pop('model')
        self.processor = kwargs.pop('processor')
        super(FilesForm, self).__init__(*args, **kwargs)

    def clean_file(self):
        file = self.cleaned_data['file']

        if self.target_model.FILE_PROCESSORS.get(self.processor).get('type') == 'import_csv' and \
                file.name.split('.')[-1] != 'csv':
            raise ValidationError(self.error_messages['invalid_csv_file'], code="invalid_file", )
        return file

    def save(self, commit=True):
        instance = super(FilesForm, self).save(commit=False)
        instance.content_object = self.target_model
        instance.process_name = self.processor
        instance.process_type = self.target_model.FILE_PROCESSORS.get(self.processor).get('type')
        instance.file_name = self.instance.file.name
        if commit:
            instance.save()
        return instance


class CSVUploadForm(FilesForm):
    class Meta:
        model = File
        fields = ['file']

    def __init__(self, *args, **kwargs):
        super(CSVUploadForm, self).__init__(*args, **kwargs)
        if not self.instance.pk:
            self.instance.columns = self.target_model.FILE_PROCESSORS.get(self.processor).get('columns')

    def save(self, commit=True):
        instance = super(CSVUploadForm, self).save(commit=False)
        instance.user_choice_columns = get_columns_names(instance.file)
        if commit:
            instance.save()
        return instance


class DownloadFileFromUrlForm(forms.ModelForm):
    url = forms.URLField(label=_('URL'), required=True)

    class Meta:
        model = File
        fields = ['url']

    def __init__(self, *args, **kwargs):
        self.target_model = kwargs.pop('model')
        self.processor = kwargs.pop('processor')
        super(DownloadFileFromUrlForm, self).__init__(*args, **kwargs)

    def save(self, commit=True):
        instance = super(DownloadFileFromUrlForm, self).save(commit=False)
        instance.content_object = self.target_model
        instance.process_name = self.processor
        instance.file_name = self.cleaned_data['url'].split('/')[-1]
        instance.process_type = self.target_model.FILE_PROCESSORS.get(self.processor).get('type')
        instance.save()
        download_from_url.delay(instance.pk, self.cleaned_data['url'])
        # response = requests.get()
        # filename = self.cleaned_data['url'].split('/')[-1]
        # file = files.File(ContentFile(response.content), filename)
        # instance.file = file
        # instance.save()
        return instance


class ProcessCSVForm(forms.Form):
    def __init__(self, file_object, processor, *args, **kwargs):
        self.processor = processor
        self.file_object = file_object
        self.user_choices = [(value, key) for key, value in file_object.user_choice_columns.items()]
        super(ProcessCSVForm, self).__init__(*args, **kwargs)
        for field in list(self.fields.keys()):
            self.fields[field].choices = self.user_choices
        if all([value is not None for key, value in self.file_object.columns.items()]):
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

    def save(self):
        instance = self.file_object
        for field, value in self.cleaned_data.items():
            instance.columns[field] = int(value)
        instance.save()
