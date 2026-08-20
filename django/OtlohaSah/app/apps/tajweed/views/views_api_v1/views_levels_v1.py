from django.db.models import Avg
from drf_yasg.utils import swagger_auto_schema
from rest_framework.generics import ListAPIView, RetrieveAPIView, get_object_or_404
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response

from apps.tajweed.models import TajweedLevel, TajweedLesson, TajweedUserProgress
from apps.tajweed.serializers import LessonSerializer
from apps.tajweed.serializers.serializers_levels import LevelStatsSerializer, LevelDetailSerializer, LevelSerializer


class LevelStatsListView(ListAPIView):
    queryset = TajweedLevel.objects.all()
    serializer_class = LevelStatsSerializer
    permission_classes = [IsAuthenticated, ]

    @swagger_auto_schema(
        operation_description="List all tajweed levels with stats of user.",
        responses={
            200: "Successful response with tajweed levels stats.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view tajweed levels",
            404: "Not Found - tajweed levels do not exist",
        }
    )
    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()

        total_lessons = TajweedLesson.objects.count()
        total_lessons_read = TajweedUserProgress.objects.filter(user=request.user, read__gt=0).count()
        total_lessons_completed = TajweedUserProgress.objects.filter(user=request.user, completed=100).count()
        total_user_rate = TajweedUserProgress.objects.filter(user=request.user).aggregate(Avg('rate'))['rate__avg']

        stats = {
            'total_lessons': total_lessons,
            'total_lessons_read': total_lessons_read,
            'total_lessons_completed': total_lessons_completed,
            'total_user_rate': total_user_rate,
        }

        serializer = self.get_serializer(queryset, context={'request': request, 'stats': stats})
        return Response(serializer.data)


class LevelRetrieveView(RetrieveAPIView):
    serializer_class = LevelDetailSerializer
    permission_classes = [AllowAny]

    @swagger_auto_schema(
        operation_description="Retrieve details of a Tajweed level by ID.",
        responses={200: LevelDetailSerializer()}
    )
    def retrieve(self, request, *args, **kwargs):
        level = TajweedLevel.objects.get(pk=self.kwargs.get('pk'))
        serializer = self.get_serializer(level)
        return Response(serializer.data)


class LevelListView(ListAPIView):
    serializer_class = LevelSerializer

    @swagger_auto_schema(
        operation_description="List all tajweed level for guest.",
        responses={
            200: "Successful response with an tajweed level",
        }
    )
    def list(self, request, *args, **kwargs):
        levels = TajweedLevel.objects.order_by('value')
        paginator = self.pagination_class()
        paginated_queryset = paginator.paginate_queryset(levels, request)
        serializer = self.get_serializer(paginated_queryset, many=True, context={'request': request})
        return paginator.get_paginated_response(serializer.data)


class LevelLessonsListView(ListAPIView):
    serializer_class = LessonSerializer
    permission_classes = [AllowAny]
    queryset = TajweedLesson.objects.all()

    @swagger_auto_schema(
        operation_description="Returns all lessons and sub-lessons that are at the specified level.",
        responses={200: LessonSerializer()}
    )
    def get(self, request, *args, **kwargs):
        level_id = kwargs.get('pk')
        level = get_object_or_404(TajweedLevel, id=level_id)
        lessons = TajweedLesson.objects.filter(lesson_level=level)

        paginator = self.pagination_class()
        paginated_queryset = paginator.paginate_queryset(lessons, request)
        serializer = self.get_serializer(paginated_queryset, many=True, context={'request': request})
        return paginator.get_paginated_response(serializer.data)
