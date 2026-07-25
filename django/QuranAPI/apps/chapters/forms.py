
from translation.forms import TranslatableModelForm

from apps.chapters.models import Chapter


class ChapterForm(TranslatableModelForm):

    class Meta:
        model = Chapter
        fields = ['name', 'origin', 'chapter_number']


