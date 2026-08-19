from django.test import TestCase
from translation.serializers import TranslatableModelSerializer

from apps.recitations.factories import ReciterFactory
from apps.recitations.models import Reciter
from apps.recitations.reciter.serializers_v1 import RecitersSerializer


class RecitersSerializerStructureTestCase(TestCase):
    def test_serializer_extends_TranslatableModelSerializer(self):
        self.assertTrue(issubclass(RecitersSerializer, TranslatableModelSerializer))

    def test_serializer_class_has_meta_class_on_it(self):
        self.assertIn('Meta', RecitersSerializer.__dict__)

    def test_the_model_used_in_the_meta_is_Reciter_Model(self):
        self.assertEqual(Reciter, RecitersSerializer.Meta.model)

    def test_id_exists_in_serializer_fields(self):
        self.assertIn('id', RecitersSerializer.Meta.fields)

    def test_name_exists_in_serializer_fields(self):
        self.assertIn('name', RecitersSerializer.Meta.fields)


class RecitersSerializerResponseTestCase(TestCase):
    def setUp(self):
        self.reciter = ReciterFactory()
        self.serializer = RecitersSerializer(instance=self.reciter)

    def test_it_returns_expected_fields(self):
        data = self.serializer.data
        self.assertEqual(set(data.keys()), {'id', 'name'})