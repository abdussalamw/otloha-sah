from app.celery import app


@app.task
def remove_teachers_from_recitations_due_to_late_response():
    from apps.settings.utils import get_setting
    from datetime import timedelta
    from django.utils.timezone import now
    from apps.recitation.models import RecitationFault
    from apps.recitation.models import Recitation
    from apps.chat.models import Room

    number_of_days = get_setting('number_of_days_before_removing_teacher_from_recitation_due_to_late_response')
    delete_date = now() - timedelta(days=number_of_days)

    recitations = Recitation.objects.filter(
        being_evaluated=True,
        evaluated_at__isnull=True,
        teacher_assigned_at__lte=delete_date
    )
    recitations_ids = recitations.values_list('id', flat=True)

    RecitationFault.objects.filter(recitation_id__in=recitations_ids).delete()
    Room.objects.filter(id__in=recitations.values_list('room', flat=True)).delete()
    recitations.update(
        teacher=None,
        teacher_assigned_at=None,
        result=None,
        being_evaluated=False,
        evaluated_at=None,
        closed_at=None,
        is_closed=False,
        show_in_general=True,
    )


@app.task()
def notify_users_about_archiving_recitations():
    pass


@app.task
def archive_recitations():
    from django.utils.timezone import now
    print(now())


@app.task
def delete_recitations_without_record():
    from apps.recitation.models import Recitation
    recitations = Recitation.objects.filter(records__isnull=True)
    for recitation in recitations:
        user_id = recitation.owner_id
        narration_id = recitation.narration_id
        chapter_id = recitation.chapter_id
        recitation.delete()

        from apps.users.utils import update_user_recitation_progress
        update_user_recitation_progress(user_id, narration_id, chapter_id)
