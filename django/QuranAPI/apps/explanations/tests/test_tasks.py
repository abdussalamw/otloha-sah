from django.contrib.contenttypes.models import ContentType
from django.core.files import File as DjangoFile
from django.test import TestCase

from apps.explanations.factories import ExplanationFactory
from apps.explanations.models import Explanation
from apps.explanations.tasks import process_csv
from apps.files_handler.models import File
from apps.narrations.factories import NarrationFactory


# class ExplanationCSVUpload(TestCase):
#     def setUp(self):
#         self.columns = {
#             'part_number': 1,
#             'chapter_number': 2,
#             'page_number': 5,
#             'verse_number': 8,
#             'text': 11,
#             'verse_text': 9,
#         }
#         file = DjangoFile(open("apps/explanations/tests/simple.csv", mode='rb'))
#         explanation = ExplanationFactory(narration=NarrationFactory())
#         self.file = File.objects.create(columns=self.columns, file=file,
#                                         content_type=ContentType.objects.get_for_model(Explanation)
#                                         , object_id=explanation.pk)
#
#     def test_process_function(self):
#         process_csv(self.file.pk)
