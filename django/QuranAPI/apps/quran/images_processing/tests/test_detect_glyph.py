import os

from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import TestCase

from apps.quran.images_processing.process import process
from apps.quran.images_processing.src.process_book import ProcessBookImages
from apps.quran.factories import BookFactory, NarrationFactory, BookCSVFactory
from apps.quran.models import BookImageUpload, BookPattern


class DetectGlyphPatternTestCase(TestCase):
    fixtures = [
        'narrations.json',
        'chapter.json',
        'part.json'
    ]

    def setUp(self):
        base_path = os.path.dirname(os.path.realpath(__file__))

        self.book = BookFactory(narration=NarrationFactory())

        file = open(base_path + '/files/images.zip', 'rb')
        marker_image = open(base_path + '/files/marker.png', 'rb')
        frame_image = open(base_path + '/files/frame.jpg', 'rb')
        csv = open(base_path + '/files/sample.csv', 'rb')
        self.uploads = BookImageUpload.objects.create(
            file=SimpleUploadedFile(content=file.read(), name=file.name, content_type='multipart/form-data'),
            book=self.book,
            number_of_pages=1)
        BookPattern.objects.create(
            book_images_uploads=self.uploads,
            file=SimpleUploadedFile(content=marker_image.read(), name=marker_image.name,
                                    content_type='multipart/form-data'),
            type='marker')
        BookPattern.objects.create(
            book_images_uploads=self.uploads,
            file=SimpleUploadedFile(content=frame_image.read(), name=frame_image.name,
                                    content_type='multipart/form-data'),
            type='frame')

        self.book_csv = BookCSVFactory(
            book=self.book,
            file=SimpleUploadedFile(content=csv.read(), name=csv.name, content_type='multipart/form-data'),
            columns={
                "line_start": 6,
                "line_end": 7,
                "part": 1,
                "text": 10,
                "uthmanic_text": 9,
                "verse_number": 8,
                "chapter": 2,
                "page": 5,
            })
        process(self.book_csv.pk)

    def test_glyph_detect(self):
        ProcessBookImages().execute(self.uploads.pk)

        # draw res glyph
