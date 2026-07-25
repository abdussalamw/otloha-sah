from django.db.models import Avg
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.shortcuts import get_object_or_404
from apps.tajweed.models.levels import UserLevelPassed
from apps.tajweed.models import TajweedUserProgress


@receiver(post_save, sender=TajweedUserProgress)
def update_parent_read(sender, instance, update_fields=None, **kwargs):
    parent = instance.parent
    children_reads = TajweedUserProgress.objects.filter(
        parent=parent
    ).aggregate(avg_read=Avg('read'))

    parent_read = TajweedUserProgress.objects.filter(
        lesson=parent
    ).values_list('read', flat=True).first()

    avg_read = children_reads['avg_read'] if children_reads['avg_read'] is not None else 0

    if parent_read is not None:
        avg_read = (avg_read + parent_read) / 2

    TajweedUserProgress.objects.filter(
        lesson=parent
    ).update(read=avg_read)


@receiver(post_save, sender=UserLevelPassed)
def update_user_progress(sender, instance, created, **kwargs):
    if created:
        user_progress_records = TajweedUserProgress.objects.filter(user=instance.user, level=instance.level)
        for progress_record in user_progress_records:
            progress_record.read = 100
            progress_record.completed = 100
            progress_record.rate = instance.rate
            TajweedUserProgress.objects.filter(
                user=instance.user, level=instance.level
            ).update(completed=100)
            progress_record.save()


@receiver(post_save, sender=UserLevelPassed)
def update_user_lesson_rate(sender, instance, **kwargs):
    def get_user_level_rate(user, level):
        user_passed = get_object_or_404(
            UserLevelPassed,
            user=user,
            level=level,
        )
        rate = user_passed.rate
        return rate

    if kwargs.get('created', False):
        level = instance.level
        user = instance.user
        passed_rate = get_user_level_rate(user, level)
        user_progress_list = TajweedUserProgress.objects.filter(level=level, user=user)
        for user_progress in user_progress_list:
            user_progress.rate = passed_rate
            user_progress.save()


