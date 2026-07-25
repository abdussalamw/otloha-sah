import os

from celery.schedules import crontab

RABBITMQ_URL = os.environ.get("RABBITMQ_URL", 'amqp://localhost')

CELERY_BROKER_URL = RABBITMQ_URL
CELERY_RESULT_BACKEND = 'django-db'

CELERY_BROKER_CONNECTION_RETRY_ON_STARTUP = True

CELERY_BEAT_SCHEDULE = {
    'remove_teachers_from_recitations_due_to_late_response': {
        'task': 'apps.recitation.tasks.remove_teachers_from_recitations_due_to_late_response',
        'schedule': crontab(minute='0', hour='0'),  # every day at midnight
    },
    # 'notify_users_about_archiving_recitations': {
    #     'task': 'apps.recitation.tasks.notify_users_about_archiving_recitations',
    #     'schedule': crontab(minute='0', hour='0'),  # every day at midnight
    # },
    # 'archive_recitations': {
    #     'task': 'apps.recitation.tasks.archive_recitations',
    #     'schedule': crontab(minute='0', hour='0'),  # every day at midnight
    # },
}
