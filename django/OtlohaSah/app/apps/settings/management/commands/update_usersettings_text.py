from django.core.management.base import BaseCommand

from apps.settings.models import UserSetting


class Command(BaseCommand):
    help = 'Update users settings text data'

    def handle(self, *args, **options):
        try:
            UserSetting.objects.update_settings_text_for_all_users()
            self.stdout.write(self.style.SUCCESS('Successfully updates the text of user settings data.'))
        except Exception as e:
            self.stderr.write(self.style.ERROR(f'An error occurred: {str(e)}'))
