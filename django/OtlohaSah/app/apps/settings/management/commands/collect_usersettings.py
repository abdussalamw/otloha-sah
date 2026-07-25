from django.core.management.base import BaseCommand

from apps.settings.models import UserSetting
from apps.users.models import User


class Command(BaseCommand):
    help = 'Collect users missing settings '

    def handle(self, *args, **options):
        try:
            for user in User.objects.filter(is_staff=False):
                UserSetting.objects.collect_missing_settings(user)
            self.stdout.write(self.style.SUCCESS('Successfully collected users settings data.'))
        except Exception as e:
            self.stderr.write(self.style.ERROR(f'An error occurred: {str(e)}'))
