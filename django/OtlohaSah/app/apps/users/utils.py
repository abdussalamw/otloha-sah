import json
from collections import defaultdict
from functools import reduce

from django.db.models import Count

from apps.users.models import User, UserProgress


def update_user_recitation_progress(user_id, narration_id, chapter_id=None):
    from apps.recitation.models import Recitation
    user = User.objects.get(id=user_id)
    recitations = user.recitations.filter(
        narration_id=narration_id).exclude(
        result=Recitation.RESULT_REPORTED)
    accepted = recitations.filter(result=Recitation.RESULT_ACCEPTED)
    rejected = recitations.filter(result=Recitation.RESULT_REJECTED)
    pending = recitations.filter(result__isnull=True)

    user_progress = UserProgress.objects.filter(
        narration_id=narration_id,
        user=user,
    )

    progress_percentage = (accepted.count() / 6236) * 100
    data = {
        "accepted_recitations": accepted.count(),
        "rejected_recitations": rejected.count(),
        "pending_recitations": pending.count(),
        "number_of_recitations": recitations.count(),
        "recitation_percentage": progress_percentage,
        "progress": {
            "recitations": {
                "accepted": map_recitation_progress(accepted),
                "rejected": map_recitation_progress(rejected),
                "pending": map_recitation_progress(pending)
            }
        }
    }
    if user_progress.exists():
        user_progress.update(**data)
    else:
        UserProgress.objects.create(narration_id=narration_id, user=user, **data)

    # if chapter_id:
    #     update_progress_socket_event(user_id, narration_id, chapter_id)


def merge_json_lists(a, b):
    b = json.loads(b) if type(b) == str else b
    a = json.loads(a) if type(a) == str else a
    result = a + b
    result.sort()
    return result


def map_recitation_progress(queryset):
    """
from apps.users.tasks import map_recitation_progress
from apps.recitation.models import Recitation
r = Recitation.objects.filter(owner_id=5, result='accepted', narration_id='1')
map_recitation_progress(r)
    """
    result = defaultdict(list)
    queryset = queryset.values('chapter_id', 'verse_ids').annotate(count=Count("chapter_id")).order_by('chapter_id')

    for item in queryset:
        result[item['chapter_id']].append(item['verse_ids'])

    for chapter, verses in result.items():
        result[chapter] = reduce(merge_json_lists, verses, [])

    return result
