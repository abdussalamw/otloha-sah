import random

import factory
from django.core.files import File as DjangoFile
from factory import post_generation
from factory.django import DjangoModelFactory

from app.config.main import BASE_DIR
from apps.users.models import User, TeacherProfile, TeacherFiles

images = [
    'static/seed/users/avatar1.png',
    'static/seed/users/avatar2.png',
    'static/seed/users/avatar3.png',
]


def get_file(path):
    filename = path.split('/')[-1]
    return DjangoFile(open(BASE_DIR / path, 'rb'), name=filename)


class TeacherFileFactory(DjangoModelFactory):
    class Meta:
        model = TeacherFiles

    file = factory.sequence(lambda n: get_file(path=images[n % 3]))
    file_type = factory.sequence(lambda n: list(dict(TeacherFiles.FILE_TYPES).keys())[n % 3])


class TeacherProfileFactory(DjangoModelFactory):
    class Meta:
        model = TeacherProfile

    teacher_type = random.choice(["volunteer", "paid"])
    status = random.choice(["pending", "approved", "rejected"])
    can_reply_on_every_verse_in_recitation = random.randint(0, 1)
    is_active = random.randint(0, 1)

    @post_generation
    def post(obj, create, extracted, **kwargs):
        for i in range(random.randint(0, 3)):
            TeacherFileFactory(teacher_profile=obj)


class UserFactory(DjangoModelFactory):
    class Meta:
        model = User
        django_get_or_create = ('phone',)

    first_name = factory.Faker('first_name')
    last_name = factory.Faker('last_name')
    username = factory.lazy_attribute(
        lambda obj: '{}.{}.{}'.format(obj.first_name, obj.last_name, random.randrange(1, 1000)))
    email = factory.lazy_attribute(lambda obj: '{}@otloha-sah.com'.format(obj.username))
    phone = factory.Sequence(lambda n: '3215616_%d' % n)
    gender = random.choice(['male', 'female'])
    password = factory.PostGenerationMethodCall('set_password', 'secret')
    is_a_teacher = random.randint(0, 1)
    image = factory.sequence(lambda n: get_file(path=images[n % 3]))
    rate = random.randint(1, 5)
