from django.contrib.auth import get_user_model
from django.db import models
from django.utils.translation import gettext as _

UserModel = get_user_model()


class SocialAccount(models.Model):
    class Meta:
        verbose_name = _("Social Account")
        verbose_name_plural = _("Social Accounts")

    user = models.ForeignKey(UserModel, on_delete=models.CASCADE, related_name="social_accounts")
    provider = models.CharField(max_length=255)
    social_id = models.CharField(unique=True, max_length=255)
    image = models.TextField(default=None, null=True, blank=True)


class SocialToken(models.Model):
    class Meta:
        verbose_name = _("Social Token")
        verbose_name_plural = _("Social Tokens")

    token = models.TextField(null=True, blank=True, default=None)
    jwt_token = models.TextField(null=True, blank=True, default=None)
    expiry = models.IntegerField(null=True)
    extra_data = models.JSONField()
    provider = models.CharField(max_length=255)
    user = models.ForeignKey(UserModel, on_delete=models.CASCADE, related_name="social_tokens")
    social_account = models.OneToOneField(SocialAccount, on_delete=models.CASCADE, related_name="token")
