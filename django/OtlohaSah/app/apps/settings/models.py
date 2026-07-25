from django import forms
from django.conf import settings
from django.contrib.auth import get_user_model
from django.db import models
from django.utils.translation import gettext_lazy as _
from translation.models import TranslatableModel

UserModel = get_user_model()


class SettingsManager(models.Manager):
    """
from apps.settings.models import Setting
Setting.objects.reset()
    """
    SETTINGS_CHOICES = [
        {
            "key": 'min_recitation_per_narration_to_get_certified_as_a_teacher_in_narration',
            "value": 10,
            "value_type": "number",
            "label": _('Minimum Recitation per Narration to Get Certified as a Teacher in Narration'),
            "group": "recitations",
            "comment": "used to "
        },
        {
            "key": 'max_number_of_replies_for_paid_teacher',
            "value": 10,
            "value_type": "number",
            "label": _('Max Number Of Replies For Paid Teacher'),
            "group": "recitations",
            "comment": "used to "
        },
        {
            "key": 'number_of_days_before_archiving_recitations',
            "value": 90,
            "value_type": "number",
            "label": _('Number Of Days Before Archiving Recitations'),
            "group": "recitations",
            "comment": "used in celery beat"
        },
        {
            "key": 'number_of_days_before_notifying_users_about_archiving_recitations',
            "value": 75,
            "value_type": "number",
            "label": _('Number Of Days Before Notifying Users About Archiving Recitations'),
            "group": "recitations",
            "comment": "used in celery beat"
        },
        {
            "key": 'number_of_days_before_removing_teacher_from_recitation_due_to_late_response',
            "value": 2,
            "value_type": "number",
            "label": _('Number of days before removing teacher from recitation due to late response'),
            "group": "recitations",
            "comment": "used in celery beat"
        },
        {
            "key": "daily_max_number_of_recitations_a_teacher_can_pull_from_general_box",
            "value": 3,
            "value_type": "number",
            "label": _("Daily Max Number Of Recitations A Teacher Can Pull From General Box"),
            "group": "recitations"
        },
        {
            "key": "daily_max_number_of_recitations_a_teacher_can_evaluate",
            "value": 3,
            "value_type": "number",
            "label": _("Daily Max Number Of Recitations A Teacher Can Evaluate"),
            "group": "recitations"
        },
        {
            "key": "min_limit_for_beginner_level",
            "value": 0.5,
            "value_type": "number",
            "label": _("Minimum Limit For Beginner Level"),
            "group": "user_levels"
        },
        {
            "key": "min_limit_for_intermediate_level",
            "value": 2.9,
            "value_type": "number",
            "label": _("Minimum Limit For Intermediate Level"),
            "group": "user_levels"
        },
        {
            "key": "min_limit_for_advanced_level",
            "value": 3.9,
            "value_type": "number",
            "label": _("Minimum Limit For Advanced Level"),
            "group": "user_levels"
        },
        {
            "key": "teacher_pricing_per_recitation",
            "value": 5,
            "value_type": "number",
            "label": _("Teacher Pricing Per Recitation"),
            "group": "pricing"
        },
    ]

    def reset(self):
        self.all().delete()
        for setting in self.SETTINGS_CHOICES:
            self.create(
                key=setting['key'],
                value=setting['value'],
                group=setting['group'],
                label=setting['label'],
                value_type=setting['value_type']
            )

    def collect_missing_settings(self):
        for setting in self.SETTINGS_CHOICES:
            setting_obj = self.filter(key=setting['key'])
            if not setting_obj.exists():
                self.create(
                    key=setting['key'],
                    value=setting['value'],
                    group=setting['group'],
                    label=setting['label'],
                    value_type=setting['value_type']
                )


class Setting(models.Model):
    SETTINGS_GROUP_RECITATIONS = 'recitations'
    SETTINGS_USER_LEVELS = 'user_levels'
    SETTINGS_PRICING = 'pricing'
    SETTINGS_GROUPS = (
        (SETTINGS_GROUP_RECITATIONS, _("Recitations")),
        (SETTINGS_USER_LEVELS, _("User Levels")),
        (SETTINGS_PRICING, _("Pricing")),
    )

    objects = SettingsManager()

    class Meta:
        verbose_name = _("Setting")
        verbose_name_plural = _("Settings")

    key = models.CharField(max_length=255, verbose_name=_("Key"))
    label = models.CharField(max_length=255, default=None, null=True, blank=True, verbose_name=_("Label"))
    value = models.TextField(verbose_name=_("Value"))
    value_type = models.TextField(default=None, null=True, blank=True, verbose_name=_("Value Type"))
    group = models.CharField(max_length=100, verbose_name=_("Group"))

    @property
    def get_group(self):
        return dict(self.SETTINGS_GROUPS).get(self.group)


class UserSettingsQueryset(models.QuerySet):
    def get_settings_choices(self, user):
        user_settings = getattr(settings, 'USER_SETTINGS_DEFAULTS', [])
        user_types = self.get_user_type(user)
        user_settings = list(filter(lambda x: x['user_type'] in user_types, user_settings))
        return user_settings

    def get_user_type(self, user):
        if user.is_a_teacher:
            return ['all', 'teacher']
        elif not user.is_a_teacher:
            return ['all', 'student']
        return ['all']

    def reset(self, group, user):
        self.filter(group=group, user=user).delete()
        for setting in self.get_settings_choices(user):
            if setting['group'] == group:
                setting = {**setting}
                setting.pop('user_type')
                self.create(**setting, user=user)

    def collect_missing_settings(self, user):
        user_settings = self.filter(user=user)
        for setting in self.get_settings_choices(user):
            setting_obj = user_settings.filter(key=setting['key'])
            if not setting_obj.exists():
                setting = {**setting}
                setting.pop('user_type')
                self.create(**setting, user=user)

    def update_settings_text_for_all_users(self):
        user_settings = getattr(settings, 'USER_SETTINGS_DEFAULTS', [])
        for setting in self.all():
            filtered_dict = next(filter(lambda d: d['key'] == setting.key, user_settings), None)
            setting.label = filtered_dict['label']
            setting.description = filtered_dict['description']
            setting.group = filtered_dict['group']
            setting.subgroup = filtered_dict['subgroup']
            setting.save()


class UserSettingsManager(models.Manager):
    def get_queryset(self):
        return UserSettingsQueryset(self.model, using=self._db)

    def reset(self, group, user):
        return self.get_queryset().reset(group, user)

    def collect_missing_settings(self, user):
        return self.get_queryset().collect_missing_settings(user)

    def update_settings_text_for_all_users(self):
        return self.get_queryset().update_settings_text_for_all_users()


class UserSetting(TranslatableModel, models.Model):
    translatable = {
        'label': {"field": forms.CharField},
    }

    class Meta:
        verbose_name = _("User Settings")

    objects = UserSettingsManager()

    key = models.CharField(max_length=255, verbose_name=_("Key"))
    label = models.JSONField(null=True, blank=True, verbose_name=_("Label"))
    description = models.JSONField(null=True, blank=True, verbose_name=_("Label"))
    value = models.TextField(verbose_name=_("Value"))
    value_type = models.TextField(default=None, null=True, blank=True, verbose_name=_("Value Type"))
    group = models.CharField(max_length=100, verbose_name=_("Group"))
    subgroup = models.CharField(max_length=100, default=None, null=True, blank=True, verbose_name=_("Subgroup"))
    user = models.ForeignKey(UserModel, related_name="settings", on_delete=models.CASCADE)


class SettingOption(TranslatableModel):
    class Meta:
        verbose_name = _("Setting Option")
        verbose_name_plural = _("Setting Options")

    setting = models.ForeignKey(UserSetting, on_delete=models.CASCADE, related_name="options")
    text = models.JSONField(null=True, blank=True, verbose_name=_("Label"))
    key = models.CharField(max_length=255, verbose_name=_("Key"))
