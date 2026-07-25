from django.apps import apps
from django.contrib.auth.models import Permission
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = 'Sync and clean permissions based on models Meta.default_permissions and permissions.'

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS('Syncing and cleaning permissions...'))

        for model in apps.get_models():
            opts = model._meta

            if not opts.default_permissions and not opts.permissions:
                continue

            default_permissions = list(opts.default_permissions)
            permissions = list(code_name for code_name, _ in opts.permissions)

            existing_permissions = set(
                perm.codename for perm in Permission.objects.filter(content_type__app_label=opts.app_label))
            model_permissions = set(codename for codename in permissions + default_permissions)

            to_delete = existing_permissions - model_permissions

            for codename in to_delete:
                permission = Permission.objects.filter(codename=codename, content_type__app_label=opts.app_label)
                permission.delete()
                self.stdout.write(self.style.SUCCESS(f'Permission deleted: {permission}'))

        self.stdout.write(self.style.SUCCESS('Syncing and cleaning permissions complete.'))
