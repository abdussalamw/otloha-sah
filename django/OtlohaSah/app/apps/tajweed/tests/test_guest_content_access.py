from django.test import TestCase
from rest_framework.test import APIClient

from apps.tajweed.models import TajweedLesson, TajweedLevel


class GuestTajweedContentQaTest(TestCase):
    def setUp(self):
        level = TajweedLevel.objects.create(
            name={'en': 'Foundation', 'ar': 'تمهيدي'},
            color='qa-blue',
            value=1,
        )
        self.level = level
        self.lesson = TajweedLesson.objects.create(
            title={'en': 'Lesson one', 'ar': 'الدرس الأول'},
            content={'en': 'Content', 'ar': 'المحتوى'},
            lesson_level=level,
        )
        self.client = APIClient()

    def test_guest_can_list_tajweed_levels(self):
        response = self.client.get('/api/v1/tajweed/levels/')
        self.assertEqual(200, response.status_code)

    def test_guest_can_list_tajweed_lessons(self):
        response = self.client.get('/api/v1/tajweed/lessons/')
        self.assertEqual(200, response.status_code)

    def test_guest_can_read_tajweed_level_and_its_lessons(self):
        level_response = self.client.get(f'/api/v1/tajweed/levels/{self.level.pk}/')
        lessons_response = self.client.get(
            f'/api/v1/tajweed/levels/{self.level.pk}/lessons/'
        )

        self.assertEqual(200, level_response.status_code)
        self.assertEqual(200, lessons_response.status_code)

    def test_guest_can_read_tajweed_lesson_details(self):
        response = self.client.get(f'/api/v1/tajweed/lessons/{self.lesson.pk}/')
        self.assertEqual(200, response.status_code)

    def test_guest_cannot_access_personal_tajweed_statistics_or_progress(self):
        stats_response = self.client.get('/api/v1/tajweed/levels/stats/')
        progress_response = self.client.put(
            f'/api/v1/tajweed/lessons/{self.lesson.pk}/progress/',
            {'read': 100, 'completed': 100, 'rate': 10},
            format='json',
        )

        self.assertIn(stats_response.status_code, {401, 403})
        self.assertIn(progress_response.status_code, {401, 403})
