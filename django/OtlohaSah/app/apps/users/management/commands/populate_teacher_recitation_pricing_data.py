from django.core.management.base import BaseCommand
from tqdm import tqdm

from apps.users.models import TeacherRecitationPricing


def populate_teacher_recitation_pricing_data(pricing):
    pricing.recitation_name = pricing.recitation.name
    pricing.save()


class Command(BaseCommand):
    help = 'Updates teacher recitation pricing data'

    def handle(self, *args, **options):
        self.stdout.write(self.style.SUCCESS('Start populating teacher recitation pricing data'))
        pricings = TeacherRecitationPricing.objects.all()

        progress_bar = tqdm(total=pricings.count(), desc='Processing', unit='iteration')

        for pricing in pricings:
            populate_teacher_recitation_pricing_data(pricing)
            progress_bar.update(1)

        progress_bar.close()

        self.stdout.write(self.style.SUCCESS('End populating teacher recitation pricing data'))
