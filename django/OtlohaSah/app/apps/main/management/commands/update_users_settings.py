from django.core.management.base import BaseCommand

from apps.users.models import User


class Command(BaseCommand):
    help = 'Updates Users Settings'

    def handle(self, *args, **kwargs):
        users = User.objects.all()
        for user in users:
            user.settings.collect_missing_settings(user)
