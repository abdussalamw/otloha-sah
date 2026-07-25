from django import forms

from apps.users.models import Teacher, TeacherProfile


class TeacherForm(forms.ModelForm):
    full_name = forms.CharField()
    teacher_type = forms.ChoiceField()

    class Meta:
        model = Teacher
        fields = (
            'full_name', 'first_name', 'last_name', 'teacher_type',
        )

    def __init__(self, *args, **kwargs):
        super(TeacherForm, self).__init__(*args, **kwargs)
        self.fields['teacher_type'].initial = self.instance.teacherprofile.teacher_type
        self.fields['teacher_type'].choices = TeacherProfile.TEACHER_TYPE

    def save(self, commit=True):
        instance = super(TeacherForm, self).save(commit=False)

        if commit:
            instance.save()
            instance.teacherprofile.fullname = self.cleaned_data['full_name']
            instance.teacherprofile.teacher_type = self.cleaned_data['teacher_type']
            instance.teacherprofile.save()
        return instance

