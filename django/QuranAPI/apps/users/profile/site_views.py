from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth.views import PasswordChangeView
from django.contrib.messages.views import SuccessMessageMixin
from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from django.urls import reverse_lazy
from django.utils.translation import gettext as _
from django.views import View

from apps.users.models import User
from apps.users.profile.forms import UpdateUserDataForm, UpdatePhoneNumberForm, UpdateEmailForm


class ProfileIndex(LoginRequiredMixin, View):
    def get(self, request):
        return render(request, 'users/profile/profile.html')


class UpdateProfileInfoView(LoginRequiredMixin, View):
    def get(self, request, user_id, *args, **kwargs):
        user = get_object_or_404(User, pk=user_id)
        return render(request, 'users/profile/update_user_data_form.html', {
            'form': UpdateUserDataForm(instance=user),
            "page_title": _("Update User Info")
        })

    def post(self, request, user_id, *args, **kwargs):
        user = get_object_or_404(User, pk=user_id)
        form = UpdateUserDataForm(request.POST, request.FILES, instance=user)
        if form.is_valid():
            form.save()
            messages.success(request, 'your profile has been updated successfully')
            return redirect(reverse('site:profile:index'))
        return render(request, 'users/profile/update_user_data_form.html', {
            'form': form
        })


class ChangePasswordView(LoginRequiredMixin, SuccessMessageMixin, PasswordChangeView):
    template_name = 'users/profile/update_user_password_form.html'
    success_message = "Successfully Changed Your Password"
    success_url = reverse_lazy('site:profile:index')


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
