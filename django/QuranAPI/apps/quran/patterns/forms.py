from django.forms import ModelForm

from apps.quran.models import BookPattern


class BookPatternForm(ModelForm):
    class Meta:
        model = BookPattern
        fields = ['file', 'type']

    def __init__(self, *args, **kwargs):
        self.book = kwargs.pop('book')
        super(BookPatternForm, self).__init__(*args, **kwargs)

    def save(self, commit=True):
        instance = super(BookPatternForm, self).save(commit=False)
        instance.book = self.book
        if commit:
            instance.save()
        return instance
