from apps.recitations import config
from apps.recitations.models import Recitation, Progress
from apps.users.models import User


def update_user_recitation_progress(user_id, narration_id):
    user = User.objects.get(id=user_id)
    recitations = Recitation.objects.filter(
        narration_id=narration_id,
        owner=user
    )
    accepted = recitations.filter(result=config.RECITATIONS_RESULT_ACCEPTED)
    rejected = recitations.filter(result=config.RECITATIONS_RESULT_REJECTED)
    pending = recitations.filter(result=config.RECITATIONS_RESULT_PENDING)

    user_progress = Progress.objects.filter(
        narration_id=narration_id,
        user=user,
    )

    data = {
        "accepted": accepted.count(),
        "rejected": rejected.count(),
        "pending": pending.count(),
        "percentage": (accepted.count() / 6236) * 100,
    }
    if user_progress.exists():
        user_progress.update(**data)
    else:
        Progress.objects.create(narration_id=narration_id, user=user, **data)
