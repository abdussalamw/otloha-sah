from translation.forms import TranslatableModelForm

from apps.quran.models import Book


class BookForm(TranslatableModelForm):
    class Meta:
        model = Book
        fields = ['name', 'narration']
