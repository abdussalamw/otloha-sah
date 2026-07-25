from django.contrib.auth.views import PasswordResetDoneView, PasswordResetConfirmView, PasswordResetCompleteView
from django.urls import path, reverse_lazy

from apps.authn.forms import SetPasswordForm
from apps.authn.views.views_admin import PasswordResetView

app_name = "password-reset"

urlpatterns = [
    path('', PasswordResetView.as_view(), name='index'),
    path("done/", PasswordResetDoneView.as_view(
        template_name="authn/password-reset/password-reset-done.html"
    ), name="done"),
    path("reset/<uidb64>/<token>/", PasswordResetConfirmView.as_view(
        template_name="authn/password-reset/password-reset-confirm-form.html",
        success_url=reverse_lazy("admin:authentication:login"),
        form_class=SetPasswordForm
    ), name="confirm"),
]
