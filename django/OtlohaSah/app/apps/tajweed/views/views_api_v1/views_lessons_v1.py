from django.db.models import Count, Avg, Q
from django.http import JsonResponse
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.generics import RetrieveAPIView, ListAPIView, get_object_or_404, UpdateAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from apps.tajweed.models import TajweedLesson, TajweedUserProgress
from apps.tajweed.serializers import LessonDetailSerializer, LessonSerializer, LessonProgressSerializer


class LessonsListView(ListAPIView):
    serializer_class = LessonSerializer
    queryset = TajweedLesson.objects.all()

    @swagger_auto_schema(
        operation_description="Retrieve a Tajweed lesson with its related video URLs and lesson examples.",
        responses={200: LessonDetailSerializer()}
    )
    def get(self, request, *args, **kwargs):
        if kwargs.get('lesson_id', None) is None:
            queryset = self.filter_queryset(self.get_queryset())
        else:
            lesson = get_object_or_404(TajweedLesson, id=kwargs.get('lesson_id', None))
            queryset = TajweedLesson.objects.filter(parent=lesson)

        queryset = self.filter_queryset(queryset)
        paginator = self.pagination_class()
        paginated_queryset = paginator.paginate_queryset(queryset, request)
        serializer = self.get_serializer(paginated_queryset, many=True, context={'request': request})
        return paginator.get_paginated_response(serializer.data)


class LessonRetrieveView(RetrieveAPIView):
    serializer_class = LessonDetailSerializer
    queryset = TajweedLesson.objects.all()

    @swagger_auto_schema(
        operation_description="Retrieve details of a Tajweed lesson by ID.",
        responses={200: LessonDetailSerializer()}
    )
    def retrieve(self, request, *args, **kwargs):
        lesson_id = kwargs.get('lesson_id')
        if kwargs.get('sup_lessons', None) is not None:
            lessons = TajweedLesson.objects.filter(parent=lesson_id)
            if not lessons.exists():
                return Response(status=status.HTTP_404_NOT_FOUND)
            serializer = self.get_serializer(lessons, many=True)
        else:
            lesson = get_object_or_404(TajweedLesson, id=lesson_id)
            serializer = self.get_serializer(lesson)
        return Response(serializer.data)


class LessonsUserStatsView(ListAPIView):
    permission_classes = [IsAuthenticated, ]

    def lesson_user_stats(self, request, *args, **kwargs):
        lesson_id = kwargs.get('lesson_id')
        lesson = get_object_or_404(TajweedLesson, id=lesson_id)
        user_progress = TajweedUserProgress.objects.filter(lesson=lesson, user=request.user)

        total_lessons = lesson.get_descendants(include_self=True).count()
        total_lessons_read = user_progress.filter(read__gt=0).count()
        total_lessons_completed = user_progress.filter(completed=100).count()
        total_user_rate = user_progress.aggregate(Avg('rate'))['rate__avg']

        stats = {
            'total_lessons': total_lessons,
            'total_lessons_read': total_lessons_read,
            'total_lessons_completed': total_lessons_completed,
            'total_user_rate': total_user_rate
        }

        return JsonResponse(stats)

    def get(self, request, *args, **kwargs):
        return self.lesson_user_stats(request, *args, **kwargs)


class LessonProgressCreateOrUpdateView(UpdateAPIView):
    permission_classes = [IsAuthenticated]
    queryset = TajweedUserProgress.objects.all()
    serializer_class = LessonProgressSerializer
    lookup_url_kwarg = 'lesson'

    def update(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        lesson = get_object_or_404(TajweedLesson, pk=self.kwargs['lesson_id'])

        instance = queryset.filter(
            user=self.request.user,
            lesson=lesson,
            level=lesson.lesson_level,
            parent=lesson.parent
        ).first()
        if instance:
            serializer = self.get_serializer(instance, data=request.data, partial=False)
            serializer.is_valid(raise_exception=True)
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            serializer.save(user=self.request.user, lesson=lesson, level=lesson.lesson_level, parent=lesson.parent)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
