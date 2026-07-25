from django.test import TestCase
from translation.serializers import TranslatableModelSerializer

from apps.explanations.factories import ExplanationFactory, ExplanationVerseFactory
from apps.explanations.models import Explanation, ExplanationVerse
from apps.explanations.serializers import ExplanationSerializer, ExplanationVerseSerializer
from apps.narrations.factories import NarrationFactory


class ExplanationSerializerStructureTestCase(TestCase):
    def test_it_extends_translatable_model_serializer(self):
        self.assertIsInstance(ExplanationSerializer(), TranslatableModelSerializer)

    def test_if_class_meta_exists(self):
        self.assertIsNotNone(ExplanationSerializer.Meta)

    def test_if_model_in_meta_extends_book_model(self):
        self.assertEqual(ExplanationSerializer.Meta.model, Explanation)

    def test_if_fields_in_meta_exists(self):
        self.assertIsNotNone(ExplanationSerializer.Meta.fields)

    def test_if_fields_in_meta_has_id_field(self):
        self.assertIn('id', list(ExplanationSerializer.Meta.fields))

    def test_if_fields_in_meta_has_name_field(self):
        self.assertIn('name', list(ExplanationSerializer.Meta.fields))

    def test_if_fields_in_meta_has_narration_field(self):
        self.assertIn('narration', list(ExplanationSerializer.Meta.fields))


class ExplanationSerializerTestCase(TestCase):
    def setUp(self):
        self.explanation = ExplanationFactory(narration=NarrationFactory())
        self.serializer = ExplanationSerializer(self.explanation)

    def test_id_field_in_the_data(self):
        self.assertIn('id', self.serializer.data.keys())

    def test_id_field_is_correct(self):
        self.assertEqual(self.serializer.data['id'], self.explanation.id)

    def test_name_field_in_the_data(self):
        self.assertIn('name', self.serializer.data.keys())

    def test_name_field_is_correct(self):
        self.assertEqual(self.serializer.data['name'], self.explanation.name['ar'])

    def test_narration_field_in_the_data(self):
        self.assertIn('narration', self.serializer.data.keys())

    def test_narration_field_is_correct(self):
        self.assertEqual(self.serializer.data['narration'], self.explanation.narration.pk)


class ExplanationVerseStructureTestCase(TestCase):
    def test_it_extends_translatable_model_serializer(self):
        self.assertIsInstance(ExplanationVerseSerializer(), TranslatableModelSerializer)

    def test_if_class_meta_exists(self):
        self.assertIsNotNone(ExplanationVerseSerializer.Meta)

    def test_if_model_in_meta_extends_explanation_verse_model(self):
        self.assertEqual(ExplanationVerseSerializer.Meta.model, ExplanationVerse)

    def test_if_fields_in_meta_exists(self):
        self.assertIsNotNone(ExplanationVerseSerializer.Meta.fields)

    def test_if_fields_in_meta_has_id_field(self):
        self.assertIn('id', list(ExplanationVerseSerializer.Meta.fields))

    def test_if_fields_in_meta_has_explanation_field(self):
        self.assertIn('explanation', list(ExplanationVerseSerializer.Meta.fields))

    def test_if_fields_in_meta_has_text_field(self):
        self.assertIn('text', list(ExplanationVerseSerializer.Meta.fields))

    def test_if_fields_in_meta_has_verse_number_field(self):
        self.assertIn('verse_number', list(ExplanationVerseSerializer.Meta.fields))

    def test_if_fields_in_meta_has_chapter_number_field(self):
        self.assertIn('chapter_number', list(ExplanationVerseSerializer.Meta.fields))

    def test_if_fields_in_meta_has_page_number_field(self):
        self.assertIn('page_number', list(ExplanationVerseSerializer.Meta.fields))


class ExplanationVerseSerializerTestCase(TestCase):
    def setUp(self):
        self.explanation = ExplanationFactory(narration=NarrationFactory())
        self.explanation_verse = ExplanationVerseFactory(explanation=self.explanation)
        self.serializer = ExplanationVerseSerializer(self.explanation_verse)

    def test_id_field_in_the_data(self):
        self.assertIn('id', self.serializer.data.keys())

    def test_id_field_is_correct(self):
        self.assertEqual(self.serializer.data['id'], self.explanation_verse.id)

    def test_explanation_field_in_the_data(self):
        self.assertIn('explanation', self.serializer.data.keys())

    def test_explanation_field_is_correct(self):
        self.assertEqual(self.serializer.data['explanation'], self.explanation_verse.explanation.pk)

    def test_text_field_in_the_data(self):
        self.assertIn('text', self.serializer.data.keys())

    def test_text_field_is_correct(self):
        self.assertEqual(self.serializer.data['text'], self.explanation_verse.text['ar'])

    def test_chapter_number_field_in_the_data(self):
        self.assertIn('chapter_number', self.serializer.data.keys())

    def test_chapter_number_field_is_correct(self):
        self.assertEqual(self.serializer.data['chapter_number'], self.explanation_verse.chapter_number)

    def test_verse_number_field_in_the_data(self):
        self.assertIn('verse_number', self.serializer.data.keys())

    def test_verse_number_field_is_correct(self):
        self.assertEqual(self.serializer.data['verse_number'], self.explanation_verse.verse_number)

    def test_part_number_field_in_the_data(self):
        self.assertIn('page_number', self.serializer.data.keys())

    def test_part_number_field_is_correct(self):
        self.assertEqual(self.serializer.data['page_number'], self.explanation_verse.page_number)

