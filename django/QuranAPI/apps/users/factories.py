import random

import factory
from django.conf import settings
from django.contrib.auth.models import Group
from django.utils.timezone import now
from factory.django import DjangoModelFactory

from apps.users.models import User


class UserFactory(DjangoModelFactory):
    class Meta:
        model = User
        django_get_or_create = ('phone',)

    first_name = factory.Faker('first_name')
    last_name = factory.Faker('last_name')
    username = factory.lazy_attribute(
        lambda obj: '{}.{}.{}'.format(obj.first_name, obj.last_name, random.randrange(1, 1000)))
    email = factory.lazy_attribute(lambda obj: '{}@quran-api.com'.format(obj.username))
    email_verified_at = now()
    phone_verified_at = now()
    phone = factory.Sequence(lambda n: '3215616_%d' % n)
    locale = random.choice(list(settings.LANGUAGES))
    gender = random.choice(['male', 'female'])
    password = factory.PostGenerationMethodCall('set_password', 'secret')


class GroupFactory(DjangoModelFactory):
    class Meta:
        model = Group
        django_get_or_create = ('name',)

    name = factory.Faker('job')
