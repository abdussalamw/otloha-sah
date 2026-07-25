import csv

from celery.utils.log import get_task_logger

from apps.chapters.models import Chapter
from apps.files_handler.models import File
from apps.narrations.models import Verse, Word
from apps.tajweed.forms import ValidationTajweedCSVForm
from apps.tajweed.models import Character

logger = get_task_logger(__name__)


def process_csv_tajweed(pk):
    file_object = File.objects.get(pk=pk)
    path = file_object.file.path
    book = file_object.content_object
    columns = file_object.columns
    chapters = Chapter.objects.all()
    verses = Verse.objects.filter(narration=book.narration)
    words = []
    has_errors = []
    to_create = []
    with open(path, 'r') as csv_file:
        data = csv.reader(csv_file, delimiter=",")
        next(data)
        for row in data:
            if row[columns['word_number']] not in words:
                words.append(row[columns['word_number']])
        data = None
        csv_file.close()
        words = Word.objects.filter(number__in=words, narration=book.narration)

    with open(path, 'r') as csv_file:
        data = csv.reader(csv_file, delimiter=",")
        next(data)

        for row in data:
            chapter = chapters.filter(chapter_number=row[columns["chapter_number"]]).first()
            verse = verses.filter(chapter_number=row[columns['chapter_number']],
                                  verse_number=row[columns['verse_number']]).first()
            word = words.filter(number=row[columns['word_number']]).first()
            character_data = {
                "character_text": row[columns['character_text']],
                "rule_text": row[columns['rule_text']],
                "word_text": word.text,
                "character_number": row[columns['character_number']],
                "word_number": word.number,
                "verse_number": row[columns['verse_number']],
                "chapter_number": row[columns['chapter_number']],
                "word": word,
                "verse": verse,
                "chapter": chapter,
                "book": book,
            }

            character_form = ValidationTajweedCSVForm(data=character_data)
            if character_form.is_valid():
                to_create.append(character_form.instance)
            else:
                has_errors.append({
                    "data": character_data,
                    "errors": character_form.errors.as_data()
                })
                logger.error(character_form.errors.as_data())

            if len(to_create) > 5000:
                Character.objects.bulk_create(to_create)
                to_create = []
                logger.info("5000 row inserted")

        Character.objects.bulk_create(to_create)
