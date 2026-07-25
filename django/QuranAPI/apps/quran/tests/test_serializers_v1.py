from django.test import TestCase
from rest_framework import serializers

from apps.quran.serializers import BookSerializer
from apps.quran.factories import *


class BookSerializerTestCase(TestCase):
    def test_it_extends_ModelSerializer(self):
        self.assertIsInstance(BookSerializer(), serializers.ModelSerializer)

    def test_if_class_meta_exists(self):
        self.assertIsNotNone(BookSerializer.Meta)

    def test_if_model_in_meta_extends_book_model(self):
        self.assertEqual(BookSerializer.Meta.model, Book)

    def test_if_fields_in_meta_exists(self):
        self.assertIsNotNone(BookSerializer.Meta.fields)

    def test_if_fields_in_meta_has_id_field(self):
        self.assertIn('id', list(BookSerializer.Meta.fields))

    def test_if_fields_in_meta_has_name_field(self):
        self.assertIn('name', list(BookSerializer.Meta.fields))

    def test_if_fields_in_meta_has_narration_field(self):
        self.assertIn('narration', list(BookSerializer.Meta.fields))
