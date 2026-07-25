from django.core.management.base import BaseCommand
from apps.users.models import TeacherRecitationPricing, TeacherProfile
from apps.recitation.models import Recitation

class Command(BaseCommand):
    help = "Populate TeacherRecitationPricing table based on accepted recitations with chunking"

    def add_arguments(self, parser):
        parser.add_argument(
            '--chunk-size',
            type=int,
            default=500,
            help="Number of records to process in each chunk (default: 500)"
        )
        parser.add_argument(
            '--price',
            type=float,
            default=0.55,
            help="Price to assign to each TeacherRecitationPricing record (default: 0.55)"
        )

    def handle(self, *args, **options):
        chunk_size = options['chunk_size']
        price = options['price']

        # Clear existing data
        self.stdout.write("Deleting all existing TeacherRecitationPricing records...")
        deleted_count, _ = TeacherRecitationPricing.objects.all().delete()
        self.stdout.write(f"Deleted {deleted_count} TeacherRecitationPricing records.")

        # Fetch accepted recitations
        self.stdout.write("Fetching accepted recitations...")
        recitations = Recitation.objects.filter(result='accepted',
                                                teacher__teacherprofile__teacher_type=TeacherProfile.TEACHER_TYPE_PAID)
        total_recitations = recitations.count()
        self.stdout.write(f"Found {total_recitations} accepted recitations.")

        # Create TeacherRecitationPricing in chunks
        pricing = []
        created_count = 0
        for i, recitation in enumerate(recitations, start=1):
            pricing.append(
                TeacherRecitationPricing(
                    teacher=recitation.teacher,
                    recitation=recitation.id,
                    recitation_name=recitation.name,
                    price=price
                )
            )

            # Bulk create in chunks
            if i % chunk_size == 0 or i == total_recitations:
                TeacherRecitationPricing.objects.bulk_create(pricing)
                created_count += len(pricing)
                self.stdout.write(f"Processed {created_count}/{total_recitations} records...")
                pricing = []  # Clear the list for the next chunk

        self.stdout.write(f"Successfully created {created_count} TeacherRecitationPricing records.")
