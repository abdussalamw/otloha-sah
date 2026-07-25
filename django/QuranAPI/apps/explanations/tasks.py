import pandas as pd
from celery.utils.log import get_task_logger

from apps.chapters.models import Chapter
from apps.explanations.forms import ValidationExplanationCSVForm
from apps.explanations.models import ExplanationVerse
from apps.files_handler.models import File
from apps.narrations.models import Verse

logger = get_task_logger(__name__)


def process_csv(pk):
    file_object = File.objects.get(pk=pk)
    file = file_object.file
    data = pd.read_csv(file)
    columns = file_object.columns
    explanation = file_object.content_object
    explanation_verses = explanation.explanationverse_set.all()
    narration = explanation.narration
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
        explanation_data = {
            "chapter_number": row.iat[0, columns['chapter_number']],
            "page_number": row.iat[0, columns['page_number']],
            "verse_number": row.iat[0, columns['verse_number']],
            "text": row.iat[0, columns['text']],
            "verse": verse,
            "chapter": chapter,
            "explanation": explanation,
        }
        explanation_verse = None
        if explanation_verses.filter(chapter=chapter, verse=verse).exists():
            explanation_verse = explanation_verses.get(chapter=chapter, verse=verse)
            explanation_verse_form = ValidationExplanationCSVForm(instance=explanation_verse, data=explanation_data)
        else:
            explanation_verse_form = ValidationExplanationCSVForm(data=explanation_data)

        if explanation_verse_form.is_valid():
            if explanation_verse:
                to_update.append(explanation_verse_form.instance)
            else:
                to_create.append(explanation_verse_form.instance)
        else:
            logger.info({
                "data": explanation_data,
                "errors": explanation_verse_form.errors.as_data()
            })

            has_errors.append({
                "data": explanation_data,
                "errors": explanation_verse_form.errors.as_data()
            })

        if len(to_create) > 5000:
            ExplanationVerse.objects.bulk_create(to_create, batch_size=5000)
            to_create = []
            logger.info("5000 row inserted")
        if len(to_update) > 5000:
            ExplanationVerse.objects.bulk_update(to_update, [
                'chapter_number', 'page_number', 'verse_number', 'text', 'verse', 'chapter', 'explanation'
            ], batch_size=5000)
            to_update = []
            logger.info("5000 row updated")

    if len(to_create):
        ExplanationVerse.objects.bulk_create(to_create, batch_size=len(to_create))
    if len(to_update):
        ExplanationVerse.objects.bulk_update(to_update, [
            'chapter_number', 'page_number', 'verse_number', 'text', 'verse', 'chapter', 'explanation'
        ], batch_size=len(to_update))
