import pandas as pd
from celery.utils.log import get_task_logger

from apps.chapters.models import Chapter
from apps.translations.forms import TranslationValidationCSVForm
from apps.files_handler.models import File
from apps.narrations.models import Verse
from apps.translations.models import TranslationVerse

logger = get_task_logger(__name__)


def process_csv(pk):
    file_object = File.objects.get(pk=pk)
    file = file_object.file
    data = pd.read_csv(file)
    columns = file_object.columns
    translation = file_object.content_object
    translation_verses = translation.translationverse_set.all()
    narration = translation.narration
    chapters = Chapter.objects.all().order_by('chapter_number')
    verses = Verse.objects.filter(narration=narration)

    to_create = []
    to_update = []
    has_errors = []

    for row_idx in range(0, len(data)):
        row = data.iloc[[row_idx]]
        chapter = chapters.get(chapter_number=row.iat[0, columns['chapter_number']])
        verse = verses.get(verse_number=row.iat[0, columns['verse_number']],
                           chapter_number=row.iat[0, columns['chapter_number']])
        translation_data = {
            "chapter_number": row.iat[0, columns['chapter_number']],
            "page_number": verse.page_number,
            "verse_number": row.iat[0, columns['verse_number']],
            "text": row.iat[0, columns['text']],
            "verse": verse,
            "chapter": chapter,
            "translation": translation,
        }
        translation_verse = None
        if translation_verses.filter(chapter=chapter, verse=verse).exists():
            translation_verse = translation_verses.get(chapter=chapter, verse=verse)
            translation_verse_form = TranslationValidationCSVForm(instance=translation_verse, data=translation_data)
        else:
            translation_verse_form = TranslationValidationCSVForm(data=translation_data)

        if translation_verse_form.is_valid():
            if translation_verse:
                to_update.append(translation_verse_form.instance)
            else:
                to_create.append(translation_verse_form.instance)
        else:
            logger.info({
                "data": translation_data,
                "errors": translation_verse_form.errors.as_data()
            })

            has_errors.append({
                "data": translation_data,
                "errors": translation_verse_form.errors.as_data()
            })

        if len(to_create) > 5000:
            TranslationVerse.objects.bulk_create(to_create, batch_size=5000)
            to_create = []
            logger.info("5000 row inserted")
        if len(to_update) > 5000:
            TranslationVerse.objects.bulk_update(to_update, [
                'chapter_number', 'page_number', 'verse_number', 'text', 'verse', 'chapter', 'translation'
            ], batch_size=5000)
            to_update = []
            logger.info("5000 row updated")

    if len(to_create):
        TranslationVerse.objects.bulk_create(to_create, batch_size=len(to_create))
    if len(to_update):
        TranslationVerse.objects.bulk_update(to_update, [
            'chapter_number', 'page_number', 'verse_number', 'text', 'verse', 'chapter', 'translation'
        ], batch_size=len(to_update))
