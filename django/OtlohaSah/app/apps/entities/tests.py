from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient

from apps.entities.models import Entity, EntityUserRole
from apps.users.models import User


class EntityViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.entity = Entity.objects.create(name="Test Entity", org_name="TestOrg", email="test@example.com",
                                            phone="+201151122345",
                                            logo="https://drive.google.com/file/d/1W17XpOmRJhJLT3JomlGydD06bChtacdl/view?usp=sharing")

    def test_entity_list_view(self):
        url = reverse('entities:entity-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)

    def test_entity_retrieve_view(self):
        url = reverse('entities:entity-detail', kwargs={'pk': self.entity.pk})
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)

    def test_entity_create_view(self):
        url = reverse('entities:entity-list')
        data = {
            'name': 'New Entity',
            'org_name': 'NewOrg',
            'email': 'new@example.com',
            'phone': "+201151122345",
            'logo': 'https://drive.google.com/file/d/1W17XpOmRJhJLT3JomlGydD06bChtacdl/view?usp=sharing'
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, 201)

    def test_entity_update_view(self):
        url = reverse('entities:entity-detail', kwargs={'pk': self.entity.pk})
        data = {
            'name': 'Updated Entity',
            'org_name': 'UpdatedOrg'
        }
        response = self.client.patch(url, data, format='json')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(Entity.objects.get(pk=self.entity.pk).name, 'Updated Entity')

    def test_entity_delete_view(self):
        url = reverse('entities:entity-detail', kwargs={'pk': self.entity.pk})
        response = self.client.delete(url)
        self.assertEqual(response.status_code, 204)
        self.assertFalse(Entity.objects.filter(pk=self.entity.pk).exists())

    def test_entity_get_by_name_view(self):
        url = reverse('entities:entity-get_by_name')
        data = {'name': self.entity.name}
        response = self.client.get(url, data)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data), 1)

    def test_entity_assign_role_view(self):
        user = User.objects.get(id=13014)
        url = reverse('entities:entity-assign_role')
        data = {
            'user': user.pk,
            'role': 'owner'
        }
        response = self.client.patch(url, data, format='json')
        self.assertEqual(response.status_code, 201)
        self.assertTrue(EntityUserRole.objects.filter(user=user, entity=self.entity, role='owner').exists())

    def test_entity_assign_role_moderator_view(self):
        user = User.objects.get(id=13014)
        url = reverse('entities:entity-assign_role')
        data = {
            'user': user.pk,
            'role': 'owner'
        }
        response = self.client.patch(url, data, format='json')
        self.assertEqual(response.status_code, 201)
        self.assertTrue(EntityUserRole.objects.filter(user=user, entity=self.entity, role='owner').exists())
