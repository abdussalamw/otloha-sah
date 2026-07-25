from django.contrib.auth.views import LoginView as BaseLoginView
from django.urls import reverse_lazy
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_protect
from django.views.generic import FormView

from apps.authn.forms import AuthenticationForm, PasswordResetForm


class LoginView(BaseLoginView):
    form_class = AuthenticationForm
    template_name = 'authn/login.html'
    redirect_authenticated_user = True


class PasswordResetView(FormView):
    template_name = 'authn/password-reset/password-reset-form.html'
    success_url = reverse_lazy("admin:authentication:password-reset:done")
    form_class = PasswordResetForm

    @method_decorator(csrf_protect)
    def dispatch(self, *args, **kwargs):
        return super().dispatch(*args, **kwargs)

    def form_valid(self, form):
        opts = {
            "host": self.request.get_host(),
            "is_secure": self.request.is_secure()
        }
        form.save(**opts)
        return super().form_valid(form)


