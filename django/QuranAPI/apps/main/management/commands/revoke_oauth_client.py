from django.core.management.base import BaseCommand, CommandError
from oauth2_provider.models import Application


class Command(BaseCommand):
    help = 'Revoke an OAuth application and all grants linked to it.'

    def add_arguments(self, parser):
        parser.add_argument('--client-id', required=True)
        parser.add_argument(
            '--confirm',
            action='store_true',
            help='Required because this invalidates the client permanently.',
        )

    def handle(self, *args, **options):
        client_id = options['client_id']
        application = Application.objects.filter(client_id=client_id).first()

        if application is None:
            raise CommandError('No OAuth application was found for the supplied client ID.')
        if not options['confirm']:
            raise CommandError('Re-run with --confirm to revoke this OAuth application.')

        application.delete()
        self.stdout.write(
            self.style.SUCCESS('OAuth application and linked grants were revoked.')
        )
