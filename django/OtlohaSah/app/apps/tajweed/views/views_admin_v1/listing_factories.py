from django.utils.translation import gettext_lazy as _
from dynamic_listing import DynamicTableFactory

from apps.tajweed.models.lessons import TajweedLesson, TajweedLessonExample, TajweedVideoUrl
from apps.tajweed.filters import TajweedLessonFilter

LessonsDynamicListingFactory = DynamicTableFactory(
    model=TajweedLesson,
    filterset_class=TajweedLessonFilter,
    listing_actions="tajweed/lessons/listing/_actions.html",
    load_rows_from_template=True,
    row_template_name='tajweed/lessons/listing/_table_row.html',
    table_columns=(
        ('id', _('ID'), 'text-center'),
        ('title', _('Title'), 'text-start'),
        ('level_lesson', _('Level'), 'text-center'),
        ('actions', _('Actions'), 'text-end'),
    )
)


ExampleDynamicListingFactory = DynamicTableFactory(
    model=TajweedLessonExample,
    listing_actions="tajweed/lessons/examples/listing/_actions.html",
    load_rows_from_template=True,
    row_template_name='tajweed/lessons/examples/listing/_table_row.html',
    table_columns=(
        ('id', _('ID'), 'text-center'),
        ('title', _('Title'), 'text-center'),
        ('chapter', _('Chapter'), 'text-center'),
        ('narration', _('Narration'), 'text-center'),
        ('verse_text', _('Verse Text'), 'text-center'),
        ('record', _('Record'), 'text-center'),
        ('actions', _('Actions'), 'text-end'),
    )
)

