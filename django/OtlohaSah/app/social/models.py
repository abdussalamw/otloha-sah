from django.contrib.auth import get_user_model
from django.db import models
from django.utils.translation import gettext_lazy as _

UserModel = get_user_model()


# class Provider(models.Model):
#     PROVIDERS = (
#         ("facebook", _("Facebook")),
#         ("google", _("Google")),
#         ("twitter", _("Twitter"))
#     )
#     name = models.CharField(max_length=255, default=None, null=True, blank=True, verbose_name=_("Name"))
#     default_provider = models.BooleanField(default=False, verbose_name=_("Default Provider"))
#     provider = models.CharField(max_length=255, choices=PROVIDERS, verbose_name=_("Provider"))
#     client_id = models.CharField(max_length=500, verbose_name=_("Client Id"))
#     client_secret = models.TextField(_("Client Secret"), null=True, blank=True, default=None)
#     is_active = models.BooleanField(default=True)
#
#     def get_provider(self):
#         return dict(self.PROVIDERS).get(self.provider)


# class Account(models.Model):
#     provider = models.ForeignKey(Provider, on_delete=models.CASCADE, verbose_name=_("Provider"))
#     user = models.ForeignKey(UserModel, on_delete=models.CASCADE, related_name="social_accounts",
#                              verbose_name=_("User"))
#     token = models.TextField(verbose_name=_("Token"))
#     expires_at = models.DateTimeField(verbose_name=_("Expires At"))
#     provider_user_id = models.BigIntegerField(_("Provider User ID"))
#     is_active = models.BooleanField(default=False)
