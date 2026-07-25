from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.viewsets import ViewSet

from apps.users import config
from apps.users.progress.serializers import BaseProgressSerializer, TeacherProgressSerializer


class ProgressViewSet(ViewSet):
    permission_classes = [IsAuthenticated]

    def get_user_progress(self, user, narration_id):
        user_progress = user.userprogress_set.filter(narration_id=narration_id)
        if user_progress.exists():
            user_progress = user_progress.first()
        else:
            from apps.users.utils import update_user_recitation_progress
            update_user_recitation_progress(user_id=user.id, narration_id=narration_id)
            user_progress = user.userprogress_set.get(narration_id=narration_id)
        return user_progress

    @action(detail=False, methods=['get'], url_path=r'(?P<narration_id>\w+)/statistics')
    def statistics(self, request, narration_id):
        user_progress = self.get_user_progress(request.user, narration_id)
        if request.user.get_user_type == config.USER_TYPE_TEACHER:
            serializer = TeacherProgressSerializer(request.user, context={'narration_id': narration_id})
        else:
            serializer = BaseProgressSerializer(user_progress)
        return Response(serializer.data)

    @action(detail=False, methods=['get'],
            url_path=r'(?P<narration_id>\w+)/(?P<progress_type>\w+)/(?P<chapters_ids>[\d,]+)')
    def progress(self, request, narration_id, progress_type, chapters_ids):
        chapters = chapters_ids.split(',')
        user_progress = self.get_user_progress(request.user, narration_id)

        progress_of_type = user_progress.progress[progress_type]
        response = {}
        for key, value in progress_of_type.items():
            response[key] = {}
            for chapter in chapters:
                if chapter in value:
                    response[key][chapter] = progress_of_type[key][chapter]

        return Response(response)


"""
    * end point for statistics
        /api/v1/progress/<int:narration_id>/statistics/
        - response: 
            {
                "accepted_recitations": "<count>,
                "rejected_recitations": "<count>,
                "pending_recitations": "<count>,
                "number_of_recitations": "<count>
            }
    
    * end point for progress
        /api/v1/progress/<int:narration_id>/chapter/<int:chapter_id>/
        - response:
            {
                "accepted": "<list: verses_ids>",
                "rejected": "<list: verses_ids>",
                "pending": "<list: verses_ids>",
            }
    
    * Progress Update Event: 
        - trigger from: 
            - evaluation
            - create recitation
            - update recitation
            - delete recitation
    
        - in main socket send event:
            {
                "type": "progress_updated",
                "message: {
                    "narration_id": "<narration_id>",
                    "chapter_id": "<chapter_id>"
                }
            }
    
        - client behaviour:
            on message:
                - re-fetch progress
                - re-fetch statistics
    
    
    """
