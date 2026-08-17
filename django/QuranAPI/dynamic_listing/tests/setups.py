import random
import django_filters
import factory
from django_filters import FilterSet

from dynamic_listing.tests.models import ProductTestModel, CategoryTestModel
from dynamic_listing.views import DynamicListView


def strtobool(value):
    normalized = str(value).strip().lower()
    if normalized in {'y', 'yes', 't', 'true', 'on', '1'}:
        return 1
    if normalized in {'n', 'no', 'f', 'false', 'off', '0'}:
        return 0
    raise ValueError(f'invalid truth value {value!r}')


class CategoryTestFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = CategoryTestModel

    name = factory.Faker('name')


class ProductTestFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = ProductTestModel

    id = factory.Faker('random_number')
    name = factory.Faker('job')
    uui = factory.Faker('')
    price = factory.Faker('random_number')
    color = factory.Faker('sentence')
    date_of_production = factory.Faker("date")
    time_of_production = factory.Faker("time")
    updated_at = factory.Faker("date_time")
    category = factory.SubFactory(CategoryTestFactory)
    is_active = factory.lazy_attribute(random.randint(0, 1))


class ProductTestFilters(FilterSet):
    BOOLEAN_CHOICES = (('false', 'False'), ('true', 'True'),)
    CHOICES = ((True, 'Oui'), (False, 'Non'))

    name = django_filters.CharFilter()
    price__gt = django_filters.NumberFilter(field_name='price', lookup_expr='gt')
    price__lt = django_filters.NumberFilter(field_name='price', lookup_expr='lt')
    price_range = django_filters.RangeFilter(lookup_expr='range')
    category_choices = django_filters.AllValuesFilter()
    is_active = django_filters.BooleanFilter()
    is_available = django_filters.BooleanFilter(choices=CHOICES)
    color = django_filters.CharFilter(lookup_expr='icontains')
    date_of_production = django_filters.DateFilter(input_formats=['%Y-%m-%d', '%d-%m-%Y'], lookup_expr='icontains')
    time_of_production = django_filters.IsoDateTimeFilter(lookup_expr='gte')
    is_published = django_filters.IsoDateTimeFromToRangeFilter(exclude=True)
    category = django_filters.ChoiceFilter(choices=ProductTestFactory())
    created_at = django_filters.RangeFilter()
    is_published_typed = django_filters.TypedChoiceFilter(choices=BOOLEAN_CHOICES,
                                                          coerce=strtobool)
    price_ordering = django_filters.OrderingFilter(
        # tuple-mapping retains order
        fields=(
            ('price', 'price')
        ),
        # labels do not need to retain order
        field_labels={
            'username': 'User account',
        }
    )


class ProductTestListView(DynamicListView):
    model = ProductTestModel
    columns = (
        ('id', 'ID'),
        ('name', 'Name'),
        ('uuid', 'UUID'),
        ('price', 'Price'),
        ('is_active', "Is Active"),
        ('is_available', "Is Available"),
        ('color', 'Color'),
        ('date_of_production', "DOP"),
        ('time_of_production', "TOP"),
        ('is_published', "Published At"),
        ('category', 'Category'),
        ('created_at', "Created At"),
        ('updated_at', "Updated At"),
    )
    title = "All Products"
    main_column = 'name'
