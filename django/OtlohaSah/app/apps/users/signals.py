from django.db.models.signals import post_save, pre_save
from django.dispatch import receiver

from apps.loggers.logs import signal_decorator
from apps.notifications.models import Via
from apps.users.models import User


@receiver(post_save, sender=User)
@signal_decorator
def publish_user_settings_to_created_user(sender, instance, created, **kwargs):
    from apps.users.tasks import publish_user_settings_to_created_user_task
    if created:
        publish_user_settings_to_created_user_task(instance.id)


@receiver(pre_save, sender=User, dispatch_uid="update_user_on_pre_save")
@signal_decorator
def update_user_on_pre_save(sender, instance, **kwargs):
    if instance.id:
        from apps.users.tasks import update_user_on_pre_save_task
        update_user_on_pre_save_task(instance.id)


@receiver(post_save, sender=User)
def create_user_notifications_via_on_user_create(sender, instance, created, **kwargs):
    notifications = [
        ('database', 'Normal Notifications'),
        ('email', 'Email Notifications'),
        ('sms', 'SMS Notifications'),
        ('push_notifications', 'Push Notifications')
    ]

    if created:
        via = []
        for key, name in notifications:
            via.append(Via(user_id=instance.id, slug=key, name=name, is_active=True))
        Via.objects.bulk_create(via)
