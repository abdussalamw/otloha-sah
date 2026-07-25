from django import forms

from apps.quran.models import Verse, Page


class UpdateVerseForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super(UpdateVerseForm, self).__init__(*args, **kwargs)

        if 'instance' in kwargs:
            self.fields['narration'].disabled = True
            self.fields['book'].disabled = True
            self.fields['chapter'].disabled = True
            self.fields['part'].disabled = True
            self.fields['page'].disabled = True

        else:
            self.fields['narration'].widget = forms.HiddenInput()
            self.fields['book'].widget = forms.HiddenInput()
            self.fields['chapter'].widget = forms.HiddenInput()
            self.fields['part'].widget = forms.HiddenInput()
            self.fields['page'].widget = forms.HiddenInput()

    class Meta:
        model = Verse
        fields = ['text', 'uthmanic_text', 'verse_number', 'page_number', 'image', 'narration', 'book', 'chapter',
                  'part', 'page']


class UpdatePageForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super(UpdatePageForm, self).__init__(*args, **kwargs)

        if 'instance' in kwargs:
            self.fields['narration'].disabled = True
            self.fields['book'].disabled = True
            # self.fields['chapter'].disabled = True
            self.fields['part'].disabled = True

        else:
            self.fields['narration'].widget = forms.HiddenInput()
            self.fields['book'].widget = forms.HiddenInput()
            # self.fields['chapter'].widget = forms.HiddenInput()
            self.fields['part'].widget = forms.HiddenInput()

    class Meta:
        model = Page
        fields = ['page_number', 'image', 'sub_part', 'narration', 'book', 'part']


