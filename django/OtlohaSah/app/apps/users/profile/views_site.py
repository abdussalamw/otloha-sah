from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import render, redirect
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View

from apps.users.profile.forms import UpdateUserDataForm, UpdatePhoneNumberForm, UpdateEmailForm


class ProfileIndex(LoginRequiredMixin, View):
    def get(self, request):
        return render(request, 'users/profile/profile.html')


class UpdateProfileInfoView(LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        return render(request, 'users/profile/update_user_data_form.html', {
            'form': UpdateUserDataForm(),
            "page_title": _("Update User Info")
        })

    def post(self, request, *args, **kwargs):
        form = UpdateUserDataForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            messages.success(request, 'your profile has been updated successfully')
            return redirect(reverse('site:profile:index'))
        return render(request, 'users/profile/update_user_data_form.html', {
            'form': form
        })


class ChangeEmailView(LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        return render(request, 'users/profile/update_email_form.html', {
            'form': UpdateEmailForm(),
            "page_title": _("Update Email")
        })

    def post(self, request, *args, **kwargs):
        user = request.user
        form = UpdateEmailForm(user, request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, 'your email has been updated successfully')
            return redirect(reverse('site:profile:index'))

        return render(request, 'users/profile/update_email_form.html', {
            'form': form
        })


class PhoneUpdateView(LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        return render(request, 'users/profile/update_phone_number_form.html', {
            'form': UpdatePhoneNumberForm(),
            "page_title": _("Update Phone Number")
        })

    def post(self, request, *args, **kwargs):
        user = request.user
        form = UpdatePhoneNumberForm(user, request.POST)
        if form.is_valid():
            request.user.phone_verified_at = None
            request.user.save()
            return redirect(reverse('site:profile:index'))

        return render(request, 'users/profile/update_phone_number_form.html', {
            "form": form
        })
