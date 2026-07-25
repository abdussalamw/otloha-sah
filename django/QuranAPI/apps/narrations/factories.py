import factory

from apps.narrations.models import Narration, Verse


class NarrationFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Narration

    name = factory.Dict({"ar": factory.Faker("job")})
    description = factory.Dict({"ar": factory.Faker("job")})


class VerseFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Verse

    text = factory.Faker("job")
    line_start = factory.Faker('random_number')
    line_end = factory.Faker('random_number')
    image = '/media/verse_pictures/example.jpg'
    verse_number = factory.Iterator(range(1, 203))
