from django.test import TestCase
from translation.serializers import TranslatableModelSerializer

from apps.parts.factories import PartFactory
from apps.parts.models import Part
from apps.parts.serializers import PartSerializer


class PartSerializerStructureTestCase(TestCase):
    def test_it_extends_translatable_model_serializer(self):
        self.assertTrue(issubclass(PartSerializer, TranslatableModelSerializer))

    # Test Meta class
    def test_it_has_meta_class(self):
        self.assertTrue(hasattr(PartSerializer, 'Meta'))
    
    def test_meta_has_model(self):
        self.assertTrue(hasattr(PartSerializer.Meta, 'model'))

    def test_meta_model_is_part(self):
        self.assertEqual(PartSerializer.Meta.model, Part)

    def test_meta_has_fields(self):
        self.assertTrue(hasattr(PartSerializer.Meta, 'fields'))

    def test_meta_fields_has_id(self):
        self.assertIn('id', PartSerializer.Meta.fields)

    def test_meta_fields_has_name(self):
        self.assertIn('name', PartSerializer.Meta.fields)

    def test_meta_fields_has_alias(self):
        self.assertIn('alias', PartSerializer.Meta.fields)

    def test_meta_fields_has_part_number(self):
        self.assertIn('part_number', PartSerializer.Meta.fields)


class PartSerializerResponseTestCase(TestCase):
    def setUp(self):
        self.part = PartFactory()
        self.serializer = PartSerializer(instance=self.part)
        self.data = self.serializer.data

    def test_it_returns_expected_fields(self):
        self.assertEqual(set(self.data.keys()), {'id', 'name', 'alias', 'part_number'})

    def test_id_has_correct_value(self):
        self.assertEqual(self.data['id'], self.part.pk)

    def test_name_has_correct_value(self):
        self.assertEqual(self.data['name'], self.part.translated_name)

    def test_alias_has_correct_value(self):
        self.assertEqual(self.data['alias'], self.part.translated_alias)

    def test_part_number_has_correct_value(self):
        self.assertEqual(self.data['part_number'], self.part.part_number)