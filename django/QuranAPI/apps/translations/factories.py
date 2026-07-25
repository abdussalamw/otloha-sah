import factory

from apps.translations.models import Translation, TranslationVerse


class TranslationFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Translation

    name = factory.Dict({"ar": factory.Faker("job")})
    author = factory.Dict({"ar": factory.Faker("job")})
    language = 'ar'


class TranslationVerseFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = TranslationVerse

    text = 'some_verse'
    chapter_number = 5
    verse_number = 1
