from django.test import TestCase
from translation.serializers import TranslatableModelSerializer

from apps.narrations.factories import NarrationFactory
from apps.recitations.factories import ReciterFactory, RecitationFactory
from apps.recitations.models import Recitation
from apps.recitations.serializers_v1 import RecitationSerializer


class RecitationSerializerStructureTestCase(TestCase):
    def test_serializer_extends_TranslatableModelSerializer(self):
        self.assertTrue(issubclass(RecitationSerializer, TranslatableModelSerializer))

    def test_serializer_class_has_meta_class_on_it(self):
        self.assertIn('Meta', RecitationSerializer.__dict__)

    def test_the_model_used_in_the_meta_is_Recitation_Model(self):
        self.assertEquals(Recitation, RecitationSerializer.Meta.model)

    def test_id_exists_in_serializer_fields(self):
        self.assertIn('id', RecitationSerializer.Meta.fields)

    def test_narration_exists_in_serializer_fields(self):
        self.assertIn('narration', RecitationSerializer.Meta.fields)

    def test_reciter_exists_in_serializer_fields(self):
        self.assertIn('reciter', RecitationSerializer.Meta.fields)

    def test_name_exists_in_serializer_fields(self):
        self.assertIn('name', RecitationSerializer.Meta.fields)


class RecitationSerializerResponseTestCase(TestCase):
    def setUp(self):
        self.reciter = ReciterFactory()
        self.recitation = RecitationFactory(
            name="{} Recitation".format(self.reciter.name),
            narration=NarrationFactory(),
            reciter=self.reciter)
        self.serializer = RecitationSerializer(instance=self.recitation)

    def test_it_returns_expected_fields(self):
        data = self.serializer.data
        self.assertEquals(set(data.keys()), {'id', 'narration', 'reciter', 'name'})

    def test_id_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['id'], self.recitation.pk)

    def test_narration_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['narration'], self.recitation.narration.pk)

    def test_reciter_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['reciter'], self.recitation.reciter.pk)

    def test_name_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['name'], self.recitation.name)
