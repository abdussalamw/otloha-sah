from django.utils.translation import gettext as _
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.generics import get_object_or_404
from rest_framework.pagination import PageNumberPagination
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from apps.recitation.models import Recitation
from apps.recitation.serializers import BaseRecitationSerializer, EvaluateRecitationSerializer, \
    RecitationGeneralBoxSerializer, RecitationRateSerializer, UpdateRecitationSerializer
from apps.users.utils import update_user_recitation_progress


class Paginator(PageNumberPagination):
    page_size = 10


class RecitationViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]

    def list(self, request, *args, **kwargs):
        user = request.user
        serializer = BaseRecitationSerializer
        if 'show_in_general' in request.GET:
            queryset = Recitation.objects.general_box(user).order_by('-created_at')
            serializer = RecitationGeneralBoxSerializer
        elif 'show_in_remarkable' in request.GET:
            queryset = Recitation.objects.user_remarkable(user).order_by('-created_at')
        elif 'is_teacher_recitation' in request.GET:
            queryset = Recitation.objects.certified_teachers_only(user).filter(
                show_in_general=True
            ).order_by('-created_at')
        elif 'my_evaluated_recitations' in request.GET:
            queryset = request.user.recitations_teacher.filter(evaluated_at__isnull=False).order_by('-evaluated_at')
        else:
            queryset = request.user.recitations.all().order_by('-created_at')

        queryset = queryset.distinct()
        paginator = Paginator()
        queryset = paginator.paginate_queryset(queryset, request)
        serializer = serializer(queryset, many=True, context={"user": self.request.user})
        return paginator.get_paginated_response(serializer.data)

    def create(self, request):
        request.data._mutable = True
        request.data['verse_ids'] = ",".join(request.data.getlist('verse_ids'))
        request.data['owner'] = request.user.pk
        request.data['show_in_remarkable'] = request.user.allow_remarkable_recitations_to_public

        serializer = BaseRecitationSerializer(data=request.data, context={"user": request.user})

        if serializer.is_valid():
            instance = serializer.save()
            return Response(BaseRecitationSerializer(
                instance=instance,
                context={"user": request.user}).data, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)

    def get(self, request, pk):
        """
        - is a teacher and allowed by gender rule
        - entity admin
        - owner

        """
        recitation = get_object_or_404(Recitation, pk=pk)
        serializer = BaseRecitationSerializer(recitation)
        return Response(serializer.data)

    def update(self, request, pk):
        recitation = get_object_or_404(Recitation, pk=pk)
        if request.user != recitation.owner:
            return Response({
                "message": _("You are not the owner of this recitation, you are not allowed to preform this action!")
            })

        if recitation.result not in [Recitation.RESULT_REJECTED, None]:
            return Response({
                "message": _("You cannot update the recitation while being evaluated")
            })

        serializer = UpdateRecitationSerializer(data=request.data, instance=recitation)
        if serializer.is_valid():
            serializer.save()
            return Response(BaseRecitationSerializer(
                instance=recitation,
                context={"user": request.user}).data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)

    def partial_update(self, request, pk=None):
        user = request.user
        recitation = get_object_or_404(Recitation.objects.all(), pk=pk)
        action = request.POST.get('status')
        allowed_actions = [
            'toggle_show_in_general', 'toggle_show_in_remarkable'
        ]
        if action in allowed_actions and hasattr(recitation, str(action)) and callable(
                getattr(recitation, str(action))):
            call = getattr(recitation, str(action))
            message, success = call(user)
            if success:
                return Response({'message': message}, status=status.HTTP_200_OK)
            return Response({'message': message}, status=status.HTTP_403_FORBIDDEN)
        return Response(status=status.HTTP_422_UNPROCESSABLE_ENTITY)

    def destroy(self, request, pk=None):
        recitation = get_object_or_404(Recitation, pk=pk)
        if request.user == recitation.owner and not recitation.being_evaluated:
            data = {
                "user_id": recitation.owner_id,
                "narration_id": recitation.narration_id,
                "chapter_id": recitation.chapter_id
            }
            recitation.delete()
            update_user_recitation_progress(**data)
            return Response({
                'message': _("Recitation Deleted Successfully")
            }, status=status.HTTP_204_NO_CONTENT)

        return Response({
            'message': _("unauthorized")
        }, status=status.HTTP_403_FORBIDDEN)

    @action(detail=True, methods=['post'], name="evaluate")
    def finish_evaluation(self, request, pk):
        recitation = get_object_or_404(Recitation, pk=pk)

        serializer = EvaluateRecitationSerializer(
            data=request.data,
            instance=recitation,
            user=request.user)

        if serializer.is_valid():
            serializer.save()
            return Response({
                "message": _("Recitation evaluated successfully")
            }, status=status.HTTP_200_OK)

        return Response(
            serializer.errors,
            status=status.HTTP_422_UNPROCESSABLE_ENTITY)

    @action(detail=True, methods=['post'])
    def rate_teacher_response(self, request, pk, *args, **kwargs):
        recitation = get_object_or_404(Recitation, pk=pk)
        serializer = RecitationRateSerializer(
            data=request.data,
            instance=recitation,
            user=request.user
        )
        if serializer.is_valid():
            serializer.save()
            return Response({
                "message": _("Conversation Rated Successfully!")
            })

        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)
