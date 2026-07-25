import distutils.dir_util
import json
import os

import pandas as pd
from celery.utils.log import get_task_logger
from django.conf import settings
from pyarabic import araby

from app.celery import app
from apps.chapters.models import Chapter
from apps.files_handler.models import File
from apps.narrations.forms import NarrationVerseCSVValidationForm, NarrationWordCSVValidationForm
from apps.narrations.models import Verse, Word, Narration
from apps.narrations.verses.serializers import VerseSerializer
from apps.parts.models import Part

logger = get_task_logger(__name__)


def process_verses_csv(pk):
    file_object = File.objects.get(pk=pk)
    file = file_object.file
    narration = file_object.content_object
    columns = file_object.columns
    parts = Part.objects.all().order_by('part_number')
    chapters = Chapter.objects.all().order_by('chapter_number')
    verses = Verse.objects.filter(narration=narration)
    to_create = []
    has_errors = []

    data = pd.read_csv(file)

    for row_idx in range(0, len(data)):
        row = data.iloc[[row_idx]]

        part = parts.filter(part_number=row.iat[0, columns['part']]).first()
        chapter = chapters.filter(chapter_number=row.iat[0, columns['chapter']]).first()

        verse_data = {
            "line_start": row.iat[0, columns['line_start']],
            "line_end": row.iat[0, columns['line_end']],
            "text": row.iat[0, columns['text']],
            "searchable_text": araby.strip_diacritics(row.iat[0, columns['text']]),
            "verse_number": row.iat[0, columns['verse_number']],
            "chapter_number": row.iat[0, columns['chapter']],
            "part_number": row.iat[0, columns['part']],
            "narration": narration,
            "chapter": chapter,
            "part": part,
            "page_number": row.iat[0, columns['page']]
        }

        verse = None
        if verses.filter(chapter=chapter, verse_number=row.iat[0, columns['verse_number']]).exists():
            verse = verses.get(chapter=chapter, verse_number=row.iat[0, columns['verse_number']])
            verse_form = NarrationVerseCSVValidationForm(instance=verse, data=verse_data)
        else:
            verse_form = NarrationVerseCSVValidationForm(data=verse_data)

        if verse_form.is_valid():
            if verse:
                verse_form.save()
            else:
                to_create.append(verse_form.instance)
        else:
            has_errors.append({
                "data": verse_data,
                "errors": verse_form.errors.as_data()
            })

    Verse.objects.bulk_create(to_create)

    for chapter in chapters:
        chapter_verses = chapter.chapter_verses.all().order_by('verse_number')
        if chapter_verses.count():
            chapter.chapternarration_set.update_or_create(narration=narration, defaults={
                "narration": narration,
                'number_of_verses': chapter_verses.count(),
                'from_page': chapter_verses.first().page_number,
                'to_page': chapter_verses.last().page_number,
            })


#
# def process_words_csv(pk):
#     csv = File.objects.get(pk=pk)
#     file = csv.file
#     pd.set_option('display.max_rows', None)
#     data = pd.read_csv(file)
#     narration = csv.content_object
#     columns = csv.columns
#     verses = narration.narration_verses.all().order_by('chapter_number', 'verse_number')
#     has_errors = []
#     for row_idx in range(0, len(data)):
#         row = data.iloc[[row_idx]]
#
#         verse = verses.filter(chapter_number=row.iat[0, columns['chapter_number']],
#                               verse_number=row.iat[0, columns['verse_number']]).first()
#
#         word_data = {
#             "text": row.iat[0, columns['text']],
#             "number": row.iat[0, columns['number']],
#             "verse_number": row.iat[0, columns['verse_number']],
#             "chapter_number": row.iat[0, columns['chapter_number']],
#             "narration": narration,
#             "verse": verse,
#         }
#
#         word = None
#         if Word.objects.filter(narration=narration,
#                                number=row.iat[0, columns['number']],
#                                chapter_number=row.iat[0, columns['chapter_number']],
#                                verse_number=row.iat[0, columns['verse_number']]).exists():
#             word = verse.verse_words.get(narration=narration,
#                                          number=row.iat[0, columns['number']],
#                                          chapter_number=row.iat[0, columns['chapter_number']],
#                                          verse_number=row.iat[0, columns['verse_number']])
#             word_form = NarrationWordCSVValidationForm(instance=word, data=word_data)
#         else:
#             print('there')
#             word_form = NarrationWordCSVValidationForm(data=word_data)
#
#         if word_form.is_valid():
#             word_form.save()
#         else:
#             has_errors.append({
#                 "data": word_data,
#                 "errors": word_form.errors.as_data()
#             })


def process_words_csv(pk):
    file_object = File.objects.get(pk=pk)
    narration = file_object.content_object
    columns = file_object.columns
    path = file_object.file.path

    data = pd.read_csv(path)

    verses = narration.narration_verses.all().order_by('chapter_number', 'verse_number')
    words = Word.objects.filter(narration=narration)

    has_errors = []
    to_create = []
    to_update = []

    for row_idx in range(0, len(data)):
        row = data.iloc[[row_idx]]
        verse = verses.filter(chapter_number=row.iat[0, columns['chapter_number']],
                              verse_number=row.iat[0, columns['verse_number']]).first()
        word_data = {
            "text": row.iat[0, columns['text']],
            "number": row.iat[0, columns['number']],
            "verse_number": row.iat[0, columns['verse_number']],
            "chapter_number": row.iat[0, columns['chapter_number']],
            "position_in_line": row.iat[0, columns['position_in_line']],
            "line_number": row.iat[0, columns['line_number']],
            "page_number": row.iat[0, columns['page_number']],
            "narration": narration,
            "verse": verse,
        }

        word = None
        if words.filter(number=row.iat[0, columns['number']]).exists():
            word = words.get(number=row.iat[0, columns['number']])
            word_form = NarrationWordCSVValidationForm(instance=word, data=word_data)
        else:
            word_form = NarrationWordCSVValidationForm(data=word_data)

        if word_form.is_valid():
            if word:
                to_update.append(word_form.instance)
            else:
                to_create.append(word_form.instance)
        else:
            logger.info({
                "data": word_data,
                "errors": word_form.errors.as_data()
            })

            has_errors.append({
                "data": word_data,
                "errors": word_form.errors.as_data()
            })

        if len(to_create) > 5000:
            Word.objects.bulk_create(to_create, batch_size=5000)
            to_create = []
            logger.info("5000 row inserted")
        if len(to_update) > 5000:
            Word.objects.bulk_update(to_update, [
                'text', 'number', 'verse_number', 'chapter_number', 'position_in_line', 'line_number',
                'page_number'], batch_size=5000)
            to_update = []
            logger.info("5000 row updated")

    if len(to_create):
        Word.objects.bulk_create(to_create, batch_size=len(to_create))
    if len(to_update):
        Word.objects.bulk_update(to_update, [
            'text', 'number', 'verse_number', 'chapter_number', 'position_in_line', 'line_number', 'page_number'],
                                 batch_size=len(to_update))

    # with open(path, 'r') as csv_file:
    #     data = csv.reader(csv_file, delimiter=",")
    #     next(data)
    #
    #     # verses = narration.narration_verses.all().order_by('chapter_number', 'verse_number')
    #     # has_errors = []
    #     # to_create = []
    #     # to_update = []
    #     # words = Word.objects.filter(narration=narration)
    #
    #     for row in data:
    #         verse = verses.filter(chapter_number=row[columns['chapter_number']],
    #                               verse_number=row[columns['verse_number']]).first()
    #         word_data = {
    #             "text": row[columns['text']],
    #             "number": row[columns['number']],
    #             "verse_number": row[columns['verse_number']],
    #             "chapter_number": row[columns['chapter_number']],
    #             "position_in_line": row[columns['position_in_line']],
    #             "line_number": row[columns['line_number']],
    #             "page_number": row[columns['page_number']],
    #             "narration": narration,
    #             "verse": verse,
    #         }
    #
    #         word = None
    #         if words.filter(number=row[columns['number']]).exists():
    #             word = words.get(number=row[columns['number']])
    #             word_form = NarrationWordCSVValidationForm(instance=word, data=word_data)
    #         else:
    #             word_form = NarrationWordCSVValidationForm(data=word_data)
    #
    #         if word_form.is_valid():
    #             if word:
    #                 to_update.append(word_form.instance)
    #             else:
    #                 to_create.append(word_form.instance)
    #         else:
    #             logger.info({
    #                 "data": word_data,
    #                 "errors": word_form.errors.as_data()
    #             })
    #
    #             has_errors.append({
    #                 "data": word_data,
    #                 "errors": word_form.errors.as_data()
    #             })
    #
    #         if len(to_create) > 5000:
    #             Word.objects.bulk_create(to_create, batch_size=5000)
    #             to_create = []
    #             logger.info("5000 row inserted")
    #         if len(to_update) > 5000:
    #             Word.objects.bulk_update(to_update, [
    #                 'text', 'number', 'verse_number', 'chapter_number', 'position_in_line', 'line_number',
    #                 'page_number'], batch_size=5000)
    #             to_update = []
    #             logger.info("5000 row updated")
    #
    #     if len(to_create):
    #         Word.objects.bulk_create(to_create, batch_size=len(to_create))
    #     if len(to_update):
    #         Word.objects.bulk_update(to_update, [
    #             'text', 'number', 'verse_number', 'chapter_number', 'position_in_line', 'line_number', 'page_number'],
    #                                  batch_size=len(to_update))


@app.task
def create_narration_json_file(pk):
    narration = Narration.objects.get(pk=pk)
    verses = narration.narration_verses.all().order_by('chapter_number', 'verse_number')
    serializer = VerseSerializer(verses, many=True)

    distutils.dir_util.mkpath(settings.MEDIA_ROOT + '/narrations/')
    media_path = 'narrations/{}.json'.format(narration.id)
    path = os.path.join(settings.MEDIA_ROOT, media_path)
    with open(path, 'w') as file:
        json.dump(serializer.data, file, ensure_ascii=False)
        narration.json_file.name = media_path
        narration.save()


"""
from apps.narrations.tasks import create_narration_json_file
create_narration_json_file(1)
"""
