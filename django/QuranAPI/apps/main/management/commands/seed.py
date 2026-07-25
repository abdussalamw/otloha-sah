import json

from django.contrib.contenttypes.models import ContentType
from django.core.management.base import BaseCommand

from apps.quran.factories import BookFactory
from apps.quran.models import Narration


class Command(BaseCommand):
    help = 'Fills Database with Fake Data'
    book = None

    def handle(self, *args, **kwargs):
        from django.core.management import call_command
        call_command('flush', '--noinput')
        self.load_modules()

        self.book = BookFactory(name={"ar": "مصحف المدينة"}, narration=Narration.objects.first())

        call_command('createsuperuser', '--email=test@aol.com', '--phone=123')

    def load_modules(self):
        fixtures = [
            'fixtures/narration.json',
            'fixtures/chapter.json',
            'fixtures/part.json',
            'fixtures/reciters.json',
            'fixtures/recitations.json',
        ]

        for fixture in fixtures:
            from itertools import groupby
            self.stdout.write(self.style.HTTP_INFO("loading Fixture: {}".format(fixture)))
            with open(fixture, 'r') as file:
                data = json.load(file)
                for k, v in groupby(data, key=lambda x: x['model']):
                    app, model = k.split('.')
                    content_type = ContentType.objects.get_by_natural_key(app, model)

                    model = content_type.model_class()
                    items = []
                    for item in data:
                        # items.append(model(**{"pk": item["pk"], **item['fields']}))
                        model.objects.create(**item['fields'])
                self.stdout.write(self.style.SUCCESS("Fixture loaded: {}".format(fixture)))

