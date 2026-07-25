from django.apps import AppConfig


class LoggersConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.loggers'

    def ready(self):
        from . import signals  # noqa
