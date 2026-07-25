from django.utils.translation import gettext as _
from dynamic_listing import DynamicListFactory, DynamicTableFactory

from apps.users.filters import StudentFilter, BaseTeacherRecitationPricingFilter, GroupAdminsFilter
from apps.users.models import TeacherRecitationPricing, TeacherNarration, Student, Admin

TeacherAccountingTablefactory = DynamicTableFactory(
    model=TeacherRecitationPricing,
    load_rows_from_template=True,
    filterset_class=BaseTeacherRecitationPricingFilter,
    row_template_name='users/admin/details/tab_contents/partials/accounting/__table_row.html',
    bulk_actions='users/admin/details/tab_contents/partials/accounting/__bulk_actions.html',
    header_template_name='users/admin/details/tab_contents/partials/accounting/__header.html',
    listing_actions='users/admin/details/tab_contents/partials/accounting/__listing_actions.html',
    table_columns=(
        ("id", _("ID")),
        ("recitation", _("Recitation"), 'text-start min-w-200px'),
        ("price", _("Price"), 'text-center'),
        ("is_paid", _("Is Paid"), 'text-center'),
        ("created_at", _("Created At"), 'text-center'),
        ("paid_at", _("Paid At"), 'text-center'),
        ("actions", _("Actions"), 'text-center'),
    )
)
TeacherNarrationsListFactory = DynamicListFactory(
    model=TeacherNarration,
    item_template_name='users/admin/details/tab_contents/partials/certifications/_list_item.html',
)

StudentsDynamicListingFactory = DynamicListFactory(
    model=Student,
    filterset_class=StudentFilter,
    header_template_name='users/admin/details/tab_contents/partials/__students_header.html',
    item_template_name='users/admin/listing/list_item/_students.html'
)

AdminDynamicTableFactory = DynamicTableFactory(
    model=Admin,
    filterset_class=GroupAdminsFilter,
    load_rows_from_template=True,
    row_template_name='groups/users/_table_row.html',
    modals_template_name='groups/users/_modals.html',
    bulk_actions='groups/users/_bulk_actions.html',
    listing_actions='groups/users/_listing_actions.html',
    table_columns=(
        ('id', _("ID")),
        ("user", _("User"), 'text-start min-w-200px'),
        ("is_active", _("Is Active"), 'text-center'),
        ("date_joined", _("Joined At"), 'text-center'),
        ("actions", _("Actions"), 'text-end'),
    )

)
