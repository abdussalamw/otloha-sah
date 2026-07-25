import factory

from .models import Part


class PartFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Part

    name = factory.Dict({"ar": factory.Faker("job")})
    alias = factory.Dict({"ar": factory.Faker("job")})
    part_number = factory.Faker('random_number')
