import factory

from .models import Reciter, Recitation, RecitationVerse


class ReciterFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Reciter

    name = factory.Dict({"ar": factory.Faker("job")})


class RecitationFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Recitation

    name = factory.Dict({"ar": factory.Faker("job")})


class RecitationVerseFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = RecitationVerse

    verse_number = factory.Iterator(range(1, 203))