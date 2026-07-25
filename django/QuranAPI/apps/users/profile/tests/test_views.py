import inspect

from django.contrib.auth.forms import PasswordChangeForm
from django.contrib.auth.mixins import LoginRequiredMixin
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.timezone import now
from django.utils.translation import gettext as _
from django.utils.translation import gettext_lazy as _
from django.views import View

from apps.users.factories import UserFactory
from apps.users.profile.forms import UpdateUserDataForm, UpdateEmailForm, UpdatePhoneNumberForm
from apps.users.profile.site_views import ChangePasswordView, PhoneUpdateView


class UpdateProfileInfoGetViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('site:profile:profile-update', args=[self.user.pk])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "users/profile/update_user_data_form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_BlogForm(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], UpdateUserDataForm)

    def test_context_contains_page_title(self):
        response = self.client.get(self.url)
        self.assertIn("page_title", response.context)

    def test_context_page_title_is_instance_of_Update_form(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['page_title'], _("Update User Info"))


class UpdateProfileInfoPostViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory(first_name='abc', last_name='xyz')
        self.client.login(email=self.user.email, password='secret')
        self.form = UpdateUserDataForm(instance=self.user)
        self.url = reverse('site:profile:profile-update', args=[self.user.pk])
        self.data = {
            "first_name": "Test",
            "last_name": "User",
            "gender": "male",
            'image': '/media/page_pictures/example.jpg',
            "birthdate": now(),
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url, data=self.data)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.post(self.url)
        self.assertTemplateUsed(response, "users/profile/update_user_data_form.html")

    def test_context_contains_form_on_error(self):
        response = self.client.post(self.url, data={})
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_UpdateUserDataForm(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], UpdateUserDataForm)

    def test_it_redirect_to_success_url(self):
        response = self.client.post(self.url, data=self.data)
        self.assertRedirects(response, reverse('site:profile:index'))


class UpdateEmailViewGetTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory(username='test@test.test', password='secret')
        self.client.login(username=self.user.email, password='secret')
        self.url = reverse('site:profile:email-update')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "users/profile/update_email_form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_Update_Email_Form(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], UpdateEmailForm)

    def test_context_contains_page_title(self):
        response = self.client.get(self.url)
        self.assertIn("page_title", response.context)

    def test_context_page_title_is_instance_of_Update_form(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['page_title'], _("Update Email"))


class UpdateEmailViewPostTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory(username='test@test.test', password='secret')
        self.client.login(username=self.user.email, password='secret')
        self.url = reverse('site:profile:email-update')
        self.data = {
            "new_email": 'test101@test.test',
            "password": "secret",
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url, data=self.data)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.post(self.url)
        self.assertTemplateUsed(response, "users/profile/update_email_form.html")

    def test_context_contains_form(self):
        response = self.client.post(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_Update_Email_Form(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], UpdateEmailForm)

    def test_it_redirect_to_success_url(self):
        response = self.client.post(self.url, data=self.data)
        self.assertRedirects(response, reverse('site:profile:index'))


class UpdatePhoneViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory(phone="+201005263988")
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('site:profile:phone-update')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "users/profile/update_phone_number_form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_Update_Phone_Form(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], UpdatePhoneNumberForm)

    def test_context_contains_page_title(self):
        response = self.client.get(self.url)
        self.assertIn("page_title", response.context)

    def test_context_page_title_is_instance_of_Update_form(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['page_title'], _("Update Phone Number"))


class UpdatePhoneViewTestCase(TestCase):
    def test_it_extends_django_class_base_view(self):
        self.assertTrue(issubclass(PhoneUpdateView, View))

    def test_it_extends_django_login_required_mixin(self):
        self.assertTrue(issubclass(PhoneUpdateView, LoginRequiredMixin))

    def test_it_has_get_attribute(self):
        self.assertTrue(hasattr(PhoneUpdateView, 'get'))

    def test_it_has_post_attribute(self):
        self.assertTrue(hasattr(PhoneUpdateView, 'post'))

    def test_get_attribute_is_callable(self):
        self.assertTrue(callable(PhoneUpdateView.get))

    def test_post_attribute_is_callable(self):
        self.assertTrue(callable(PhoneUpdateView.post))

    def test_get_signature(self):
        expected_signature = ['self', 'request', ]
        actual_signature = inspect.getfullargspec(PhoneUpdateView.get)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_post_signature(self):
        expected_signature = ['self', 'request', ]
        actual_signature = inspect.getfullargspec(PhoneUpdateView.post)[0]
        self.assertEquals(actual_signature, expected_signature)


class UpdatePhoneViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory(phone="+201001452369")
        self.client.login(username=self.user.email, password='secret')
        self.url = reverse('site:profile:phone-update')
        self.data = {
            "new_phone": '+201005263977',
            "password": "secret",
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url, data=self.data)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.post(self.url)
        self.assertTemplateUsed(response, "users/profile/update_phone_number_form.html")

    def test_context_contains_form(self):
        response = self.client.post(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_Update_Phone_Form(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], UpdatePhoneNumberForm)

    def test_it_rerender_form_on_failure(self):
        UserFactory(phone='+201005263977')
        response = self.client.post(self.url, self.data)
        self.assertTemplateUsed(response, "users/profile/update_phone_number_form.html")

    def test_it_redirect_to_success_url(self):
        response = self.client.post(self.url, data=self.data)
        self.assertRedirects(response, reverse('site:profile:index'))


class ChangePasswordViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('site:profile:password-change')
        self.change_password = ChangePasswordView()

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.post(self.url)
        self.assertTemplateUsed(response, "users/profile/update_user_password_form.html")

    def test_it_returns_200_when_updated_successfully(self):
        response = self.client.post(self.url)
        self.assertEquals(response.status_code, 200)

    def test_it_returns_the_right_success_message(self):
        self.assertEquals(self.change_password.success_message, "Successfully Changed Your Password")

    def test_it_redirect_to_success_url(self):
        self.assertEquals(self.change_password.success_url, reverse('site:profile:index'))

    def test_it_the_form_used(self):
        self.assertEquals(self.change_password.form_class, PasswordChangeForm)
