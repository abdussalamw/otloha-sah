from django.contrib.contenttypes.models import ContentType
from django.core.files import File as DjangoFile
from django.test import TestCase

from apps.chapters.factories import ChapterFactory
from apps.files_handler.models import File
from apps.tajweed.factories import RuleFactory, TajweedBookFactory
from apps.tajweed.models import Book
from apps.tajweed.tasks import process_csv_tajweed


class TajweedCSVUpload(TestCase):
    def setUp(self):
        self.columns = {
            'word_text': 3,
            'word_number': 2,
            'character_number': 8,
            'character_text': 7,
            'verse_number': 4,
            'chapter_number': 6,
            'verse_text': 5,
            'rule': 1,
        }
        chapter = ChapterFactory(chapter_number=1)
        file = DjangoFile(open("apps/tajweed/tests/simple_char.csv", mode='rb'))
        self.book = TajweedBookFactory()
        rule = RuleFactory(tajweed_book=self.book)
        self.file = File.objects.create(columns=self.columns, file=file,
                                        content_type=ContentType.objects.get_for_model(Book)
                                        , object_id=self.book.pk)

    def test_process_function(self):
        process_csv_tajweed(self.book.pk)
