from django.contrib.auth.mixins import LoginRequiredMixin
from drf_yasg.utils import swagger_auto_schema
from rest_framework import exceptions
from rest_framework import status
from rest_framework.decorators import permission_classes
from rest_framework.generics import ListAPIView, RetrieveAPIView
from rest_framework.generics import UpdateAPIView, DestroyAPIView, get_object_or_404, CreateAPIView
from rest_framework.permissions import IsAdminUser
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet

from apps.tajweed import config
from apps.tajweed.models import ExamReservation
from apps.tajweed.models.calendar import CalendarSlot
from apps.tajweed.models.lessons import TajweedLesson
from apps.tajweed.models.lessons import TajweedLessonExample, TajweedVideoUrl
from apps.tajweed.models.levels import TajweedLevel
from apps.tajweed.models.levels import UserLevelPassed
from apps.tajweed.serializers import CalendarSlotSerializer, \
    ExamReservationAdminSerializer, UserLevelPassedSerializer, TajweedLessonExampleSerializer, TajweedVideoUrlSerializer
from apps.tajweed.serializers import TajweedLevelSerializer, TajweedLessonSerializer, VerseSerializer
from quran_api_client.models import Verse


def has_permission(user, permissions, operator='and'):
    """
    Check if a user has the specified permissions.

    Args:
        user (User): The user whose permissions need to be checked.
        permissions (str or list of str): The permission(s) to check.
        operator (str): The logical operator to use when checking multiple permissions.
            Possible values are 'and' and 'or'. Default is 'and'.

    Raises:
        PermissionDenied: If the user does not have the required permissions.

    Returns:
        None
    """
    if not isinstance(permissions, list):
        permissions = [permissions]
    has_perms = user.has_perms(permissions) if operator == 'and' else any([user.has_perm(perm) for perm in permissions])
    if not has_perms:
        raise exceptions.PermissionDenied()


class TajweedLevelViewSet(ModelViewSet, LoginRequiredMixin):
    queryset = TajweedLevel.objects.all()
    serializer_class = TajweedLevelSerializer
    permission_classes([IsAdminUser])

    @swagger_auto_schema(
        operation_description="List all Tajweed levels.",
        responses={
            200: "Successful response with all tajweed level.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The user is not authorized to view levels",
            404: "Not Found - Levels do not exist",
        }
    )
    def list(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.view_tajweedlevel')
        return super().list(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="List details of specific level.",
        responses={
            200: "Successful response with a tajweed level.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to view this level",
            404: "Not Found - Level does not exist",
        }
    )
    def retrieve(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.view_tajweedlevel')
        return super().retrieve(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Create a new Tajweed level.",
        responses={
            201: "Tajweed Level created successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to create level"
        }
    )
    def create(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.add_tajweedlevel')
        return super().create(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Update a Tajweed level.",
        responses={
            200: "Tajweed Level updated successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to update level"
        }
    )
    def update(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.change_tajweedlevel')
        return super().update(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Partially update a Tajweed level.",
        responses={
            200: "Tajweed Level updated successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to update level"
        }
    )
    def partial_update(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.change_tajweedlevel')
        return super().partial_update(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Delete a Tajweed level.",
        responses={
            204: "Tajweed Level deleted successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to delete level"
        }
    )
    def destroy(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.delete_tajweedlevel')
        return super().destroy(request, *args, **kwargs)


class TajweedLessonViewSet(LoginRequiredMixin, ModelViewSet):
    queryset = TajweedLesson.objects.all()
    serializer_class = TajweedLessonSerializer
    permission_classes([IsAdminUser])

    @swagger_auto_schema(
        operation_description="List all Tajweed lessons.",
        responses={
            200: "Successful response with all tajweed lessons.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The user is not authorized to view lessons",
            404: "Not Found - Lessons do not exist",
        }
    )
    def list(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.view_tajweedlesson')
        return super().list(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="List details of specific lesson.",
        responses={
            200: "Successful response with a tajweed lesson.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to view this lesson",
            404: "Not Found - Lesson does not exist",
        }
    )
    def retrieve(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.view_tajweedlesson')
        return super().retrieve(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Create a new Tajweed lesson.",
        responses={
            201: "Tajweed lesson created successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to create lesson"
        }
    )
    def create(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.add_tajweedlesson')
        return super().create(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Create a new Tajweed lesson.",
        responses={
            200: "Tajweed lesson updated successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to update lesson"
        }
    )
    def update(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.change_tajweedlesson')
        return super().update(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Create a new Tajweed lesson.",
        responses={
            200: "Tajweed Level updated successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to update lesson."
        }
    )
    def partial_update(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.change_tajweedlesson')
        return super().partial_update(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Create a new Tajweed lesson.",
        responses={
            204: "Tajweed lesson deleted successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to update lesson"
        }
    )
    def destroy(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.delete_tajweedlesson')
        return super().destroy(request, *args, **kwargs)


class CalendarSlotViewSet(LoginRequiredMixin, ModelViewSet):
    queryset = CalendarSlot.objects.all()
    serializer_class = CalendarSlotSerializer
    permission_classes([IsAdminUser])

    @swagger_auto_schema(
        operation_description="List all Calendar Slots.",
        responses={
            200: "Successful response with all Calendar Slots.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The user is not authorized to Calendar Slots",
            404: "Not Found - Lessons do not exist",
        }
    )
    def list(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.view_calendarslot')
        return super().list(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="List details of specific Calendar Slot.",
        responses={
            200: "Successful response with a tajweed Calendar Slot.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to view this Calendar Slot",
            404: "Not Found - Calendar Slot does not exist",
        }
    )
    def retrieve(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.view_calendarslot')
        return super().retrieve(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Create a new Tajweed Calendar Slot.",
        responses={
            201: "Tajweed Calendar Slot created successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to create Calendar Slot"
        }
    )
    def create(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.add_calendarslot')
        return super().create(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Create a new Tajweed Calendar Slot.",
        responses={
            200: "Tajweed Calendar Slot updated successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to update Calendar Slot"
        }
    )
    def update(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.change_calendarslot')
        return super().update(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Create a new Tajweed Calendar Slot.",
        responses={
            200: "Tajweed Level updated successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to update Calendar Slot."
        }
    )
    def partial_update(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.change_calendarslot')
        return super().partial_update(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Create a new Tajweed Calendar Slot.",
        responses={
            204: "Tajweed Calendar Slot deleted successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to update Calendar Slot"
        }
    )
    def destroy(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.delete_calendarslot')
        return super().destroy(request, *args, **kwargs)


class ExamReservationListAPIView(LoginRequiredMixin, ListAPIView):
    queryset = ExamReservation.objects.all()
    permission_classes([IsAdminUser])
    serializer_class = ExamReservationAdminSerializer


class ApproveAndRejectExamReservationUpdateAPIView(LoginRequiredMixin, UpdateAPIView):
    queryset = ExamReservation.objects.all()
    permission_classes = [IsAdminUser]
    serializer_class = ExamReservationAdminSerializer

    def patch(self, request, **kwargs):
        has_permission(request.user, 'tajweed.change_examreservation')
        exam_reservation = get_object_or_404(ExamReservation, id=kwargs.get('pk'))

        if exam_reservation.status != config.STATUS_PENDING:
            return Response({"error": "Exam reservation already updated."}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)

        serializer = self.get_serializer(exam_reservation, data={
            "status": kwargs.get('status'),
            "meeting_link": request.data.get('meeting_link'),
            "notes": request.data.get('notes')
        }, partial=True, context={'request': request, 'kwargs': kwargs})

        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(serializer.data, status=status.HTTP_200_OK)


class ExamReservationDeleteAPIView(LoginRequiredMixin, DestroyAPIView):
    queryset = ExamReservation.objects.all()
    permission_classes = [IsAdminUser]

    @swagger_auto_schema(
        operation_description="Delete Tajweed Exam Reservation.",
        responses={
            204: "Tajweed Exam Reservation deleted successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to update Exam Reservation"
        }
    )
    def destroy(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.delete_examreservation')
        return super().destroy(request, *args, **kwargs)


class UserLevelPassedViewSet(LoginRequiredMixin, ModelViewSet):
    queryset = UserLevelPassed.objects.all()
    serializer_class = UserLevelPassedSerializer
    permission_classes([IsAdminUser])

    @swagger_auto_schema(
        operation_description="List all Tajweed User Level Passed.",
        responses={
            200: "Successful response with all  User Level Passed.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The user is not authorized to view  User Level Passed.",
            404: "Not Found - Levels do not exist",
        }
    )
    def list(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.view_userlevelpassed')
        return super().list(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="List details of specific User Level Passed..",
        responses={
            200: "Successful response with a tajweed User Level Passed..",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to view this  User Level Passed.",
            404: "Not Found - Level does not exist",
        }
    )
    def retrieve(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.view_userlevelpassed')
        return super().retrieve(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Create a new Tajweed User Level Passed.",
        responses={
            201: "Tajweed User Level Passed created successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to create level"
        }
    )
    def create(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.add_userlevelpassed')
        return super().create(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Update a User Level Passed.",
        responses={
            200: "Tajweed User Level Passed updated successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to update User Level Passed"
        }
    )
    def update(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.change_userlevelpassed')
        return super().update(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Partially update a User Level Passed.",
        responses={
            200: "Tajweed User Level Passed updated successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to update User Level Passed"
        }
    )
    def partial_update(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.change_userlevelpassed')
        return super().partial_update(request, *args, **kwargs)

    @swagger_auto_schema(
        operation_description="Delete a Tajweed User Level Passed.",
        responses={
            204: "Tajweed User Level Passed deleted successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to delete User Level Passed"
        }
    )
    def destroy(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.delete_userlevelpassed')
        return super().destroy(request, *args, **kwargs)


class TajweedLessonExampleListAPIView(LoginRequiredMixin, ListAPIView):
    queryset = TajweedLessonExample.objects.all()
    serializer_class = TajweedLessonExampleSerializer
    permission_classes = [IsAdminUser]

    @swagger_auto_schema(
        operation_description="List all Tajweed Lesson Examples.",
        responses={
            200: "Successful response with a list of Tajweed Lesson Examples.",
            401: "Unauthorized - The admin is Unauthorized"
        }
    )
    def get(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.view_tajweedlessonexample')
        lesson_id = kwargs.get('lesson')
        examples = TajweedLessonExample.objects.filter(lesson_id=lesson_id)
        serializer = self.get_serializer(examples, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class TajweedLessonExampleCreateAPIView(LoginRequiredMixin, CreateAPIView):
    queryset = TajweedLessonExample.objects.all()
    permission_classes = [IsAdminUser]
    serializer_class = TajweedLessonExampleSerializer

    def post(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.add_tajweedlessonexample')
        serializer = self.get_serializer(data={
            "lesson": kwargs.get('lesson'),
            "title": request.data.get('title'),
            "record_url": request.data.get('record_url'),
            "verse": request.data.get('verse')
        })

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class TajweedLessonExampleUpdateAPIView(LoginRequiredMixin, UpdateAPIView):
    permission_classes = [IsAdminUser]
    serializer_class = TajweedLessonExampleSerializer

    @swagger_auto_schema(
        operation_description="Update an existing Tajweed Lesson Example.",
        responses={
            200: "Tajweed Lesson Example updated successfully.",
            400: "Bad request - Invalid input data.",
            401: "Unauthorized - The admin is Unauthorized",
            404: "Not Found - The specified Tajweed Lesson Example does not exist."
        }
    )
    def put(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.change_tajweedlessonexample')
        example = TajweedLessonExample.objects.get(pk=kwargs.get('pk'))
        serializer = self.get_serializer(example, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class TajweedLessonExampleDeleteAPIView(LoginRequiredMixin, DestroyAPIView):
    permission_classes = [IsAdminUser]

    @swagger_auto_schema(
        operation_description="Delete an existing Tajweed Lesson Example.",
        responses={
            204: "Tajweed Lesson Example deleted successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to delete the Tajweed Lesson Example.",
            404: "Not Found - The specified Tajweed Lesson Example does not exist."
        }
    )
    def delete(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.delete_tajweedlessonexample')
        example = TajweedLessonExample.objects.get(pk=kwargs.get('pk'))
        example.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class TajweedVideoUrlListAPIView(LoginRequiredMixin, ListAPIView):
    queryset = TajweedVideoUrl.objects.all()
    permission_classes = [IsAdminUser]
    serializer_class = TajweedVideoUrlSerializer

    @swagger_auto_schema(
        operation_description="List all Tajweed Video URLs.",
        responses={
            200: "Successful response with a list of Tajweed Video URLs.",
            401: "Unauthorized - The admin is Unauthorized"
        }
    )
    def get(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.view_tajweedvideourl')
        return super().list(request, *args, **kwargs)


class TajweedVideoUrlCreateAPIView(LoginRequiredMixin, CreateAPIView):
    queryset = TajweedVideoUrl.objects.all()
    permission_classes = [IsAdminUser]
    serializer_class = TajweedVideoUrlSerializer

    @swagger_auto_schema(
        operation_description="Create a new Tajweed Video URL.",
        responses={
            201: "Tajweed Video URL created successfully.",
            400: "Bad request - Invalid input data.",
            401: "Unauthorized - The admin is Unauthorized"
        }
    )
    def post(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.add_tajweedvideourl')
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class TajweedVideoUrlUpdateAPIView(LoginRequiredMixin, UpdateAPIView):
    permission_classes = [IsAdminUser]
    serializer_class = TajweedVideoUrlSerializer

    @swagger_auto_schema(
        operation_description="Update an existing Tajweed Video URL.",
        responses={
            200: "Tajweed Video URL updated successfully.",
            400: "Bad request - Invalid input data.",
            401: "Unauthorized - The admin is Unauthorized",
            404: "Not Found - The specified Tajweed Video URL does not exist."
        }
    )
    def put(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.change_tajweedvideourl')
        video_url = TajweedVideoUrl.objects.get(pk=kwargs.get('pk'))
        serializer = self.get_serializer(video_url, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class TajweedVideoUrlDeleteAPIView(LoginRequiredMixin, DestroyAPIView):
    permission_classes = [IsAdminUser]

    @swagger_auto_schema(
        operation_description="Delete an existing Tajweed Video URL.",
        responses={
            204: "Tajweed Video URL deleted successfully.",
            401: "Unauthorized - The admin is Unauthorized",
            403: "Forbidden - The admin is not authorized to delete the Tajweed Video URL.",
            404: "Not Found - The specified Tajweed Video URL does not exist."
        }
    )
    def destroy(self, request, *args, **kwargs):
        has_permission(request.user, 'tajweed.delete_tajweedvideourl')
        video_url = TajweedVideoUrl.objects.get(pk=kwargs.get('pk'))
        video_url.destroy()
        return Response(status=status.HTTP_204_NO_CONTENT)


class VerseListAPIView(ListAPIView):
    permission_classes = [IsAuthenticated, ]
    serializer_class = VerseSerializer

    def get_queryset(self):
        narration = self.kwargs['narration_id']
        chapter = self.kwargs['chapter_id']
        return Verse.objects.filter(narration=narration, chapter=chapter)


class VerseDetailAPIView(RetrieveAPIView):
    queryset = Verse.objects.all()
    serializer_class = VerseSerializer
    lookup_field = 'id'
