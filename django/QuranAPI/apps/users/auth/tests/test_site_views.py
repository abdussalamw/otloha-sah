from django.contrib.auth import get_user_model
from django.contrib.auth.views import LoginView
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.timezone import now

from apps.users.auth.forms import RegisterForm, AuthenticationForm
from apps.users.auth.views_site import AuthenticateView
from apps.users.factories import UserFactory


class RegisterViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.url = reverse('auth:register')

    def test_it_redirects_to_user_dashboard_if_logged_in(self):
        user = UserFactory()
        self.client.login(email=user.email, password="secret")
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('site:main:home'))

    def test_it_returns_register_template(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "users/auth/register.html")

    def test_it_returns_form_in_response_context(self):
        response = self.client.get(self.url)
        self.assertIn('form', response.context)

    def test_response_context_form_is_instance_of_register_form(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], RegisterForm)


class RegisterViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.url = reverse('auth:register')
        self.data = {
            "email": "test@test.test",
            "username": "Test User",
            "phone": "+201005263988",
            "password1": "newTESTPasswordD",
            "password2": "newTESTPasswordD",
            "first_name": "Test",
            "last_name": "User",
            "gender": "male",
            "birthdate": now(),
        }

    def test_it_redirects_to_user_dashboard_if_logged_in(self):
        user = UserFactory()
        self.client.login(email=user.email, password="secret")
        response = self.client.post(self.url, self.data)
        self.assertRedirects(response, reverse('site:main:home'))

    def test_it_creates_user_with_provided_data(self):
        response = self.client.post(self.url, self.data)
        self.assertTrue(get_user_model().objects.filter(email="test@test.test").exists())

    def test_it_log_the_created_user_in(self):
        self.client.post(self.url, self.data)
        self.assertIn('_auth_user_id', self.client.session)
        self.assertEquals(self.client.session['_auth_user_id'],
                          str(get_user_model().objects.get(email="test@test.test").id))

    def test_it_redirect_to_next_if_next_in_request(self):
        self.data.update({"next": '/'})
        response = self.client.post(self.url, self.data)
        self.assertRedirects(response, '/')

    def test_it_redirects_to_user_dashboard_if_next_is_not_provided(self):
        response = self.client.post(self.url, self.data)
        self.assertRedirects(response, reverse('site:main:home'))

    def test_it_returns_register_template_if_form_is_invalid(self):
        self.data.pop('email')
        response = self.client.post(self.url, self.data)
        self.assertTemplateUsed(response, "users/auth/register.html")

    def test_it_returns_form_in_response_context_if_form_is_invalid(self):
        self.data.pop('email')
        response = self.client.post(self.url, self.data)
        self.assertIn('form', response.context)

    def test_response_context_form_is_instance_of_register_form_if_form_is_invalid(self):
        self.data.pop('email')
        response = self.client.post(self.url, self.data)
        self.assertIsInstance(response.context['form'], RegisterForm)


class LoginViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.url = reverse('auth:login')

    def test_it_extends_django_LoginView(self):
        self.assertIsInstance(AuthenticateView(), LoginView)

    def test_it_redirects_to_user_dashboard_if_logged_in(self):
        self.client.login(email=self.user.email, password="secret")
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('site:main:home'))

    def test_it_uses_login_template(self):
        response = self.client.get(reverse("auth:login"))
        self.assertTemplateUsed(response, 'users/auth/login.html')

    def test_it_returns_form_in_context(self):
        response = self.client.get(reverse("auth:login"))
        self.assertIn('form', response.context)

    def test_it_context_username_form_is_instance_of_AuthenticationForm(self):
        response = self.client.get(reverse("auth:login"))
        self.assertIsInstance(response.context['form'], AuthenticationForm)


class LoginViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.url = reverse('auth:login')
        self.data = {
            "username": self.user.email,
            "phone": self.user.phone,
            "password": "secret",
            "remember_me": False
        }

    def test_it_extends_django_LoginView(self):
        self.assertIsInstance(AuthenticateView(), LoginView)

    def test_it_redirects_to_user_dashboard_if_logged_in(self):
        self.client.login(email=self.user.email, password="secret")
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('site:main:home'))

    def test_it_logs_in_with_username_and_password(self):
        self.data.pop('phone')
        response = self.client.post(self.url, self.data)
        self.assertRedirects(response, reverse('site:main:home'))

    def test_it_logs_in_with_phone_and_password(self):
        self.data.pop('username')
        response = self.client.post(self.url, self.data)
        self.assertRedirects(response, reverse('site:main:home'))

    def test_it_uses_login_template_if_data_is_invalid(self):
        self.data.update({'password': "21351351"})
        self.data.pop('username')
        response = self.client.post(self.url, self.data)
        self.assertTemplateUsed(response, 'users/auth/login.html')

    def test_it_returns_form_in_context_if_data_is_invalid(self):
        self.data.update({'password': "21351351"})
        self.data.pop('username')
        response = self.client.post(self.url, self.data)
        self.assertIn('form', response.context)

    def test_it_context_username_form_is_instance_of_AuthenticationForm_if_data_is_invalid(self):
        self.data.update({'password': "21351351"})
        self.data.pop('username')
        response = self.client.post(self.url, self.data)
        self.assertIsInstance(response.context['form'], AuthenticationForm)


# class VerifyPhoneViewGETTestCase(TestCase):
#     def setUp(self):
#         self.client = Client()
#         self.user = UserFactory()
#         self.client.login(username=self.user.email, password="secret")
#
#     def test_it_redirects_to_login_if_user_is_not_logged_in(self):
#         self.client.logout()
#         response = self.client.get(reverse("auth:verify-phone"))
#         self.assertRedirects(response, reverse("auth:login") + '?next=/verify/phone/')
#
#     def test_it_redirects_to_user_dashboard_if_user_s_phone_is_verified(self):
#         self.user.phone_verified_at = now()
#         self.user.save()
#         response = self.client.get(reverse("auth:verify-phone"))
#         self.assertRedirects(response, reverse('site:main:home'))
#
#     def test_it_returns_verify_phone_template(self):
#         response = self.client.get(reverse("auth:verify-phone"))
#         self.assertTemplateUsed(response, 'users/auth/verify_phone.html')
#
#     def test_it_returns_form_in_response_context(self):
#         response = self.client.get(reverse("auth:verify-phone"))
#         self.assertIn('form', response.context)
#
#     def test_response_context_form_is_instance_of_verify_phone_form(self):
#         response = self.client.get(reverse("auth:verify-phone"))
#         self.assertIsInstance(response.context['form'], VerifyPhoneForm)


# class VerifyPhoneViewPOSTTestCase(TestCase):
#     def setUp(self):
#         self.client = Client()
#         self.user = UserFactory(phone="201002536987")
#         self.client.login(username=self.user.email, password="secret")
#
#     def test_it_redirects_to_login_if_user_is_not_logged_in(self):
#         self.client.logout()
#         response = self.client.post(reverse("auth:verify-phone"))
#         self.assertRedirects(response, reverse("auth:login") + '?next=/verify/phone/')
#
#     def test_it_redirects_to_user_dashboard_if_user_s_phone_is_verified(self):
#         self.user.phone_verified_at = now()
#         self.user.save()
#         response = self.client.post(reverse("auth:verify-phone"))
#         self.assertRedirects(response, reverse('site:main:home'))
#
#     @override_settings(PHONE_VERIFY_SERVICE="apps.users.auth.tests.mocks.MockVerifyService")
#     def test_it_fails_if_code_is_not_valid(self):
#         response = self.client.post(reverse("auth:verify-phone"), {"code": "852356"})
#         self.assertTemplateUsed(response, 'users/auth/verify_phone.html')
#
#     @override_settings(PHONE_VERIFY_SERVICE="apps.users.auth.tests.mocks.MockVerifyService")
#     def test_it_redirects_to_user_dashboard_on_success(self):
#         response = self.client.post(reverse("auth:verify-phone"), {"code": "777777"})
#         self.assertRedirects(response, reverse('site:main:home'))
#
#     @freeze_time("2012-01-14")
#     @override_settings(PHONE_VERIFY_SERVICE="apps.users.auth.tests.mocks.MockVerifyService")
#     def test_it_updates_user_phone_verified_at(self):
#         self.client.post(reverse("auth:verify-phone"), {"code": "777777"})
#         self.user.refresh_from_db()
#         self.assertEquals(self.user.phone_verified_at, now())
#
#     def test_it_returns_verify_phone_template_on_failure(self):
#         response = self.client.get(reverse("auth:verify-phone"))
#         self.assertTemplateUsed(response, 'users/auth/verify_phone.html')
#
#     def test_it_returns_form_in_response_context_on_failure(self):
#         response = self.client.get(reverse("auth:verify-phone"))
#         self.assertIn('form', response.context)
#
#     def test_response_context_form_is_instance_of_verify_phone_form_on_failure(self):
#         response = self.client.get(reverse("auth:verify-phone"))
#         self.assertIsInstance(response.context['form'], VerifyPhoneForm)
