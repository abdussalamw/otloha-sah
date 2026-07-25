from django.test import TestCase
from translation.serializers import TranslatableModelSerializer

from apps.narrations.factories import NarrationFactory
from apps.narrations.models import Narration
from apps.narrations.serializers import NarrationSerializer


class NarrationSerializerStructureTestCase(TestCase):
    def test_it_extends_translatable_model_serializer(self):
        self.assertTrue(issubclass(NarrationSerializer, TranslatableModelSerializer))

    # Test Meta class
    def test_it_has_meta_class(self):
        self.assertTrue(hasattr(NarrationSerializer, 'Meta'))
    
    def test_meta_has_model(self):
        self.assertTrue(hasattr(NarrationSerializer.Meta, 'model'))

    def test_meta_model_is_narration(self):
        self.assertEqual(NarrationSerializer.Meta.model, Narration)

    def test_meta_has_fields(self):
        self.assertTrue(hasattr(NarrationSerializer.Meta, 'fields'))

    def test_meta_fields_has_id(self):
        self.assertIn('id', NarrationSerializer.Meta.fields)

    def test_meta_fields_has_name(self):
        self.assertIn('name', NarrationSerializer.Meta.fields)

    def test_meta_fields_has_description(self):
        self.assertIn('description', NarrationSerializer.Meta.fields)

        
class NarrationSerializerResponseTestCase(TestCase):
    def setUp(self):
        self.narration = NarrationFactory()
        self.serializer = NarrationSerializer(instance=self.narration)
        self.data = self.serializer.data

    def test_it_returns_expected_fields(self):
        self.assertEqual(set(self.data.keys()), {'id', 'name', 'description'})

    def test_id_has_correct_value(self):
        self.assertEquals(self.data['id'], self.narration.pk)

    def test_name_has_correct_value(self):
        self.assertEquals(self.data['name'], self.narration.translated_name)

    def test_description_has_correct_value(self):
        self.assertEquals(self.data['description'], self.narration.translated_description)