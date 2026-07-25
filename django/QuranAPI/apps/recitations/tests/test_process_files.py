import os

from django.contrib.contenttypes.models import ContentType
from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import TestCase

from apps.chapters.factories import ChapterFactory
from apps.files_handler.models import File
from apps.narrations.factories import NarrationFactory
from apps.recitations.factories import RecitationFactory, ReciterFactory
from apps.recitations.models import Recitation, RecitationVerse


# class RecitationProcessTestCase(TestCase):
#     def setUp(self):
#         base_path = os.path.dirname(os.path.realpath(__file__))
#         file = open(base_path + '/files/001.zip', 'rb')
#         file = SimpleUploadedFile(content=file.read(), name=file.name, content_type='multipart/form-data')
#         self.recitation = RecitationFactory(reciter=ReciterFactory(), narration=NarrationFactory())
#         content_type = ContentType.objects.get_for_model(Recitation)
#         self.file = File.objects.create(file_name='001.zip', file=file, content_type=content_type,
#                                         object_id=self.recitation.pk)
#         self.chapter = ChapterFactory(chapter_number=1)
#
#     def test_it_process_recitations(self):
#         self.recitation.process_files(self.file.pk)
#         self.assertGreater(RecitationVerse.objects.count(), 0)