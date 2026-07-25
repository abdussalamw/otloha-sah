from django.contrib.auth import login
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth.views import LoginView
from django.shortcuts import render, redirect
from django.urls import reverse
from django.utils.timezone import now
from django.views import View

from apps.users.auth.forms import AuthenticationForm, RegisterForm, VerifyPhoneForm


class AuthenticateView(LoginView):
    form_class = AuthenticationForm
    authentication_form = None
    template_name = 'users/auth/login.html'
    redirect_authenticated_user = True

    def get_redirect_url(self):
        return reverse('site:main:home')


class RegisterView(View):
    def get(self, request, *args, **kwargs):
        if request.user.is_authenticated:
            return redirect(reverse('site:main:home'))

        return render(request, 'users/auth/register.html', {"form": RegisterForm()})

    def post(self, request, *args, **kwargs):
        if request.user.is_authenticated:
            return redirect(reverse('site:main:home'))

        form = RegisterForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(self.request, user, backend="apps.users.auth.backends.UsernameOrPhoneModelBackend")

            if 'next' in request.POST:
                return redirect(request.POST.get('next'))
            return redirect(reverse('site:main:home'))

        return render(self.request, 'users/auth/register.html', {
            "form": form
        })


class PhoneVerify(LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        if request.user.phone_verified_at is not None:
            return redirect(reverse('site:main:home'))

        return render(request, 'users/auth/verify_phone.html', {
            "form": VerifyPhoneForm(request.POST, user=request.user)
        })

    def post(self, request, *args, **kwargs):
        if request.user.phone_verified_at is not None:
            return redirect(reverse('site:main:home'))

        form = VerifyPhoneForm(request.POST, user=request.user)
        if form.is_valid():
            request.user.phone_verified_at = now()
            request.user.save()
            return redirect(reverse('site:main:home'))

        return render(request, 'users/auth/verify_phone.html', {
            "form": form
        })

