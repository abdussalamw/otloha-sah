from django.core.management.base import BaseCommand
from django.utils.timezone import now

from apps.recitation.factories import RecitationFactory
from apps.users import config
from apps.users.factories import TeacherProfileFactory, UserFactory
from apps.users.models import User
from quran_api_client.client import QuranAPIClient


class Command(BaseCommand):
    help = 'Fills Database with Fake Data'

    initial_users = [
        {
            "first_name": "teacher",
            "last_name": "1",
            'username': 'teacher1',
            'email': "teacher1@mail.com",
            "phone": "123456789",
            "is_a_teacher": True,
            "is_active": True,

        },
        {
            "first_name": "teacher",
            "last_name": "2",
            'username': 'teacher2',
            'email': "teacher2@mail.com",
            "phone": "123456788",
            "is_a_teacher": True,
            "is_active": True,

        },
        {
            "first_name": "teacher",
            "last_name": "3",
            'username': 'teacher3',
            'email': "teacher3@mail.com",
            "phone": "123456787",
            "is_a_teacher": True,
            "is_active": True,

        },
        {
            "first_name": "student",
            "last_name": "1",
            'username': 'student1',
            'email': "student1@mail.com",
            "phone": "123456779",
            "is_a_teacher": False,
            "is_active": True,

        },
        {
            "first_name": "student",
            "last_name": "2",
            'username': 'student2',
            'email': "student2@mail.com",
            "phone": "123456777",
            "is_a_teacher": False,
            "is_active": True,

        },
        {
            "first_name": "student",
            "last_name": "3",
            'username': 'student3',
            'email': "student3@mail.com",
            "phone": "123456778",
            "is_a_teacher": False,
            "is_active": True,

        }
    ]

    def handle(self, *args, **kwargs):
        from django.core.management import call_command
        call_command('flush', '--noinput')
        QuranAPIClient().load_initial_data()
        UserFactory(
            first_name='fritill',
            last_name='admin',
            username='fritill admin',
            email="fritill.admin@mail.com",
            phone="12345678910",
            password='admin',
            is_staff=True,
            is_superuser=True,
            is_active=True,
            language='en',
            phone_verified_at=now(),
            email_verified_at=now(),
            gender=config.GENDER_MALE,
            is_a_teacher=False
        )

        for initial_user in self.initial_users:
            user = UserFactory(**initial_user)
            if user.is_a_teacher:
                TeacherProfileFactory(
                    teacher=user,
                    is_active=True,
                    status='approved',
                    can_reply_on_every_verse_in_recitation=True,
                )
            user.refresh_from_db()
            for i in range(10):
                RecitationFactory(owner=user, gender=user.gender, is_teacher_recitation=user.is_a_teacher)

        # TeacherProfileFactory(
        #     teacher=UserFactory(
        #         username="Teacher",
        #         first_name="teacher",
        #         email="teacher@mail.com",
        #         phone="0102313515131",
        #         is_a_teacher=True,
        #         is_active=True,
        #     ),
        #     is_active=True,
        #     status='approved',
        #     can_reply_on_every_verse_in_recitation=True,
        # )

        # for i in range(20):
        #     TeacherProfileFactory(
        #         teacher=UserFactory(is_a_teacher=True, is_active=True),
        #         is_active=True,
        #         status='approved',
        #         can_reply_on_every_verse_in_recitation=True,
        #     )
        # teachers = Teacher.objects.all().exclude(email="teacher@mail.com")

        # for i in range(20):
        #     UserFactory(is_a_teacher=False, favorite_teacher=teachers.order_by('?').first())
        #
        # students = Student.objects.filter(is_active=True)
        #
        # for teacher in teachers:
        #     for i in range(5):
        #         RecitationFactory(owner=teacher, is_teacher_recitation=True, show_in_general=True, is_finished=True)
        #
        # for student in students:
        #     for i in range(5):
        #         RecitationFactory(owner=student, show_in_general=True, is_finished=True)
