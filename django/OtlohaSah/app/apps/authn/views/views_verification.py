from django.contrib import messages
from django.contrib.auth import get_user_model
from django.contrib.auth.tokens import default_token_generator
from django.shortcuts import render
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_decode
from django.utils.timezone import now
from django.utils.translation import gettext as _
from django.views import View

UserModel = get_user_model()


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

        return render(request, 'authn/templates/authn/verfiy.html',  {'messages': messages})
