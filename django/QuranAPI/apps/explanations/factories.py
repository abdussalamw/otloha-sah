import factory

from apps.explanations.models import Explanation, ExplanationVerse


class ExplanationFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Explanation

    name = factory.Dict({"ar": factory.Faker("job")})


class ExplanationVerseFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = ExplanationVerse

    text = factory.Dict({"ar": factory.Faker("job")})
    verse_number = factory.Faker('random_number')
    chapter_number = factory.Faker('random_number')
    page_number = factory.Faker('random_number')