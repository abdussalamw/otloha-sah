from django.conf import settings
from django.contrib import messages
from django.contrib.auth import get_user_model
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth.tokens import default_token_generator
from django.http import JsonResponse
from django.shortcuts import redirect
from django.urls import reverse
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.utils.timezone import now
from django.utils.translation import gettext as _
from django.views import View

from apps.authn.tasks import send_email_verification

UserModel = get_user_model()


def send_admin_email_verification(request, user):
    uid = urlsafe_base64_encode(force_bytes(user.pk))
    token = default_token_generator.make_token(user)
    verification_url = request.build_absolute_uri(
        reverse("admin:authentication:email-verification:verify", args=[uid, token])
    )
    app_url = f"{request.scheme}://{request.get_host()}"
    send_email_verification.delay(user.id, app_url, verification_url)


class SendEmailVerificationView(LoginRequiredMixin, View):
    def get(self, request):
        if request.user.email_verified_at:
            return JsonResponse({"message": _("Email is already verified!")})

        send_admin_email_verification(request, request.user)

        return JsonResponse({
            "message": _("Verification Email Sent Successfully!")
        })


class VerifyEmailView(View):
    def get(self, request, uidb64, token):
        try:
            user_id = force_bytes(urlsafe_base64_decode(uidb64))
            user = UserModel.objects.get(pk=user_id)
        except (TypeError, ValueError, OverflowError, UserModel.DoesNotExist):
            user = None

        if user is not None and default_token_generator.check_token(user, token):
            user.email_verified_at = now()
            user.save()
            messages.success(request, _('Email was verified successfully.'))
        else:
            messages.error(request, _('The link is invalid.'))

        return redirect(settings.LOGIN_REDIRECT_URL)
