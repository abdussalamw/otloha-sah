import factory

from apps.tajweed.models import *


class TajweedBookFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Book

    name = factory.Dict({"ar": factory.Faker("job")})
    author = factory.Dict({"ar": factory.Faker("job")})


class RuleFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Rule

    rule_number = 10
    name = factory.Dict({"ar": factory.Faker("job")})
    color = 'red'

#
# class VerseFactory(factory.django.DjangoModelFactory):
#     class Meta:
#         model = Verse
#
#     verse_text = factory.Dict({"ar": factory.Faker("job")})
#     verse_number = 10
#     chapter_number = 2


class CharacterFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Character

    character_text = factory.Faker("job")
    word_text = factory.Faker("word")
    rule_text = factory.Faker("job")
    character_number = 10
    verse_number = 5
    chapter_number = 2
    word_number = 6
