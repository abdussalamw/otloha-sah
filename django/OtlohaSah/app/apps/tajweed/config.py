from django.utils.translation import gettext_lazy as _

STATUS_PENDING = 'pending'
STATUS_ACCEPTED = 'accepted'
STATUS_REJECTED = 'rejected'
RESERVATION_STATUS = (
    (STATUS_PENDING, _('Pending')),
    (STATUS_ACCEPTED, _('Accepted')),
    (STATUS_REJECTED, _('Rejected')),
)

EXAM_TYPE_LEVEL_EXAM = 'level_exam'
EXAM_TYPE_REPLACEMENT_EXAM = 'replacement_exam'
RESERVATION_EXAM_TYPES = (
    (EXAM_TYPE_LEVEL_EXAM, _('Level Exam')),
    (EXAM_TYPE_REPLACEMENT_EXAM, _('Replacement Exam')),
)
