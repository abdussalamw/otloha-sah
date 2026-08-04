from django import forms
from django.core.exceptions import ValidationError
from django.db import models
from django.utils.translation import gettext_lazy as _
from apps.tajweed.models.calendar import CalendarSlot
from apps.tajweed.models.exams import ExamReservation
from apps.tajweed.models.lessons import TajweedLesson, TajweedVideoUrl, TajweedLessonExample
from apps.tajweed.models.levels import TajweedLevel, UserLevelPassed
from quran_api_client.models import Narration, Verse, Chapter


class CustomModelChoiceField(forms.ModelMultipleChoiceField):

    def to_python(self, value):
        if value in self.empty_values:
            return None
        try:
            key = self.to_field_name or "pk"
            if isinstance(value, self.queryset.model):
                value = getattr(value, key)
            value = self.queryset.model.objects.get(**{key: value})
        except (ValueError, TypeError, self.queryset.model.DoesNotExist):
            raise ValidationError(
                self.error_messages["invalid_choice"],
                code="invalid_choice",
                params={"value": value},
            )
        return value


class TajweedLevelForm(forms.ModelForm):
    class Meta:
        model = TajweedLevel
        fields = ['name', 'color', 'value']
        widgets = {
            'name': forms.TextInput(attrs={"class": "form-control"}),
            'color': forms.TextInput(attrs={'type': 'color', "class": "form-control form-control-color"}),
            'value': forms.TextInput(attrs={"class": "form-control"}),

        }

    def clean(self):
        cleaned_data = super().clean()
        name = cleaned_data.get('name')
        color = cleaned_data.get('color')
        value = cleaned_data.get('value')

        if TajweedLevel.objects.filter(name=name).exclude(pk=self.instance.pk if self.instance else None).exists():
            self.add_error('name', forms.ValidationError(_('This name already exists.')))

        if TajweedLevel.objects.filter(color=color).exclude(pk=self.instance.pk if self.instance else None).exists():
            self.add_error('color', forms.ValidationError(_('This color already exists.')))

        if TajweedLevel.objects.filter(value=value).exclude(pk=self.instance.pk if self.instance else None).exists():
            self.add_error('value', forms.ValidationError(_('This value already exists.')))

        return cleaned_data


class UserLevelPassedForm(forms.ModelForm):
    class Meta:
        model = UserLevelPassed
        fields = ['user', 'level', 'exam_record', 'rate']


class TajweedLessonForm(forms.ModelForm):
    class Meta:
        model = TajweedLesson
        fields = ['title', 'content', 'lesson_level', 'parent']

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['title'].required = True
        self.fields['content'].required = True

    def clean(self):
        cleaned_data = super().clean()
        title = cleaned_data.get('title')

        if TajweedLesson.objects.filter(title=title).exclude(pk=self.instance.pk if self.instance else None).exists():
            self.add_error('title', forms.ValidationError(_('This title already exists.')))

        return cleaned_data


class CalendarSlotForm(forms.ModelForm):
    class Meta:
        model = CalendarSlot
        fields = ['date', 'time_from', 'time_to', 'available_slots', 'reserved_slots']
        widgets = {
            'date': forms.DateInput(attrs={'type': 'date'}),
            'time_from': forms.TimeInput(attrs={'type': 'time_from'}),
            'time_to': forms.TimeInput(attrs={'type': 'time_to'}),
        }

    def clean(self):
        cleaned_data = super().clean()
        date = cleaned_data.get('date')
        time_from = cleaned_data.get('time_from')

        if CalendarSlot.objects.filter(date=date, time_from=time_from).exclude(
                pk=self.instance.pk if self.instance else None).exists():
            self.add_error('date', forms.ValidationError(_('This Slot already exists.')))

        reserved_slots = cleaned_data.get('reserved_slots')
        available_slots = cleaned_data.get('available_slots')
        if reserved_slots is not None and available_slots is not None and reserved_slots > available_slots:
            self.add_error('available_slots', forms.ValidationError(_('Reserved slots cannot exceed available slots.')))

        return cleaned_data


class ApproveExamReservationForm(forms.ModelForm):
    class Meta:
        model = ExamReservation
        fields = ['meeting_link', 'notes']


class RejectExamReservationForm(forms.ModelForm):
    class Meta:
        model = ExamReservation
        fields = ['notes']


class TajweedVideoUrlForm(forms.ModelForm):
    class Meta:
        model = TajweedVideoUrl
        fields = ['url']


class TajweedLessonExampleForm(forms.ModelForm):
    class Meta:
        model = TajweedLessonExample
        fields = ['title', 'record', 'narration', 'chapter', 'verse_number']

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['title'].required = True
        self.fields['record'].required = True
        self.fields['narration'].required = True
        self.fields['chapter'].required = True

    def clean_verse_number(self):
        cleaned_data = super().clean()
        chapter = cleaned_data.get('chapter')
        narration = cleaned_data.get('narration')
        verse_number_enter = cleaned_data.get('verse_number')

        if chapter and verse_number_enter:
            my_verse = Verse.objects.filter(
                chapter=chapter.pk,
                chapter_number=chapter.pk,
                narration=narration.pk,
            ).order_by('-id').first()
            verse_number = my_verse.verse_number
            if verse_number_enter < 1 or verse_number_enter > verse_number:
                raise forms.ValidationError(
                    f"The verse number should be between 1 and {verse_number} for the selected chapter."
                )

        return verse_number
