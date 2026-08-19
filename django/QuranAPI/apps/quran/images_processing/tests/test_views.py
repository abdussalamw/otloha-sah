from django.test import TestCase, Client
from django.urls import reverse

from apps.narrations.factories import NarrationFactory
from apps.quran.factories import BookFactory
from apps.users.factories import UserFactory


class ProcessBookImagesGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        self.url = reverse('admin:books:images:process-book', args=[self.book.pk, ])
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "quran/book/images/confirm_process_images.html")

    def test_view_extend_LoginRequiredMixin(self):
        pass

    def test_view_extend_View(self):
        pass

    def test_view_has_get_function(self):
        pass

    def test_get_method_is_callable(self):
        pass


class ProcessBookImagesPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        self.url = reverse('admin:books:images:process-book', args=[self.book.pk, ])
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_404_if_book_images_does_not_exists(self):
        pass

    def test_it_redirect_back_to_the_book_images_details(self):
        pass

    def test_view_extends_post_function(self):
        pass
