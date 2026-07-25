from django.contrib.auth.mixins import LoginRequiredMixin
from django.core.exceptions import PermissionDenied
from django.db import transaction
from django.db.models import Q, Count
from django.shortcuts import get_object_or_404
from django.utils.translation import gettext as _
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status
from rest_framework.generics import ListAPIView, DestroyAPIView, CreateAPIView, UpdateAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from apps.invitations import config
from apps.khatma.models import Khatma, KhatmaUsers
from apps.khatma.serializers.serializers_api_v1.serializers import KhatmaSerializer
from apps.users.models import User
from quran_api_client.models import Verse, Chapter


class KhatmaCreateView(LoginRequiredMixin, CreateAPIView):
    serializer_class = KhatmaSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class ListKhatmaAPIView(LoginRequiredMixin, ListAPIView):
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    serializer_class = KhatmaSerializer

    def get_queryset(self):
        user = self.request.user
        unblocked_or_unbaned_users = User.objects.unblocked_and_unblocker_users(user).unbaned_and_unbaner_users_khatma(user)
        if not user.is_a_teacher:
            queryset = Khatma.objects.annotate(
                num_teachers=Count('khatmausers', filter=Q(khatmausers__is_teacher=True)),
                num_students=Count('khatmausers', filter=Q(khatmausers__is_teacher=False)),
            ).filter(
                num_students__lt=20,
            ).filter(
                Q(created_by__in=unblocked_or_unbaned_users,
                  status=config.KHATMA_STATUS_PENDING,
                  active=True) |
                Q(created_by=user),
            ).distinct()
        else:
            queryset = Khatma.objects.annotate(
                num_students=Count('khatmausers', filter=Q(khatmausers__is_teacher=False)),
                num_teachers=Count('khatmausers', filter=Q(khatmausers__is_teacher=True)),
            ).filter(
                num_students__lt=20,
                status__in=[config.KHATMA_STATUS_PENDING, config.KHATMA_STATUS_IN_PROGRESS],
                created_by__in=unblocked_or_unbaned_users,
            ).distinct()

        return queryset


class KhatmaDeleteView(LoginRequiredMixin, DestroyAPIView):
    queryset = Khatma.objects.all()

    def destroy(self, request, *args, **kwargs):
        khatma = self.get_object()
        khatma_instance = get_object_or_404(Khatma, pk=khatma.pk)

        is_creator = request.user == khatma_instance.created_by
        is_teacher = KhatmaUsers.objects.filter(khatma=khatma_instance, user=request.user, is_teacher=True).exists()

        if not is_creator and not is_teacher:
            raise PermissionDenied("You don't have permission to delete this Khatma.")

        khatma.delete()

        return Response({'message': 'Khatma deleted successfully'})


class KhatmaStartView(UpdateAPIView):
    permission_classes = [IsAuthenticated]

    def update(self, request, *args, **kwargs):
        if not request.user.is_a_teacher:
            return Response({"error": "Only teachers can start Khatma."}, status=status.HTTP_403_FORBIDDEN)

        khatma = Khatma.objects.get(pk=kwargs.get('khatma'))
        khatma_students = KhatmaUsers.objects.filter(khatma=khatma, is_teacher=False)
        students_num = len(khatma_students)

        if students_num < 10 or not khatma.active:
            error_message = _("Khatma needs at least one teacher to start.") if not khatma.active \
                else _("Number of students in khatma is less than 10.")
            return Response({"error": error_message}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)

        distinct_verses = Verse.objects.filter(
            narration=khatma.narration,
            part_number__range=(khatma.from_part.part_number, khatma.to_part.part_number)
        ).order_by('part_number', 'chapter_number', 'verse_number').distinct(
            'narration_id', 'part_number', 'chapter_number', 'verse_number')

        verses_num = distinct_verses.count()
        verses_per_student = verses_num // students_num
        students_with_extra_verse = verses_num % students_num
        start_index = 0
        with transaction.atomic():
            for student in khatma_students:
                end_index = start_index + verses_per_student
                if students_with_extra_verse > 0:
                    end_index += 1
                    students_with_extra_verse -= 1

                student_verses = list(distinct_verses[start_index:end_index])
                student.from_verse = student_verses[0]
                student.to_verse = student_verses[-1]

                student.from_chapter = Chapter.objects.filter(
                    chapter_number=student.from_verse.chapter_number).first() if student.from_verse else None
                student.to_chapter = Chapter.objects.filter(
                    chapter_number=student.to_verse.chapter_number).first() if student.to_verse else None

                student.save()
                start_index = end_index

        khatma.status = config.KHATMA_STATUS_IN_PROGRESS
        khatma.save()

        return Response({"message": _("Khatma started successfully.")}, status=status.HTTP_200_OK)


class KhatmaFinishView(UpdateAPIView):
    permission_classes = [IsAuthenticated]

    def update(self, request, *args, **kwargs):
        if not request.user.is_a_teacher:
            return Response({"error": "Only users with is_a_teacher=True can start Khatma."},
                            status=status.HTTP_403_FORBIDDEN)
        khatma = Khatma.objects.get(pk=kwargs.get('khatma'))
        khatma.status = config.KHATMA_STATUS_FINISHED
        khatma.save()
        return Response({"message": "Khatma finished successfully."}, status=status.HTTP_200_OK)


class KhatmaUserDeleteView(DestroyAPIView):
    queryset = KhatmaUsers.objects.all()

    def destroy(self, request, *args, **kwargs):
        khatma_id = self.kwargs['khatma']
        user_id = self.kwargs['user']

        khatma_user = get_object_or_404(KhatmaUsers, khatma__id=khatma_id, user__id=user_id)
        khatma_instance = get_object_or_404(Khatma, pk=khatma_id)

        is_creator = request.user == khatma_instance.created_by
        is_teacher = KhatmaUsers.objects.filter(khatma=khatma_instance, user=request.user, is_teacher=True).exists()

        if not is_creator and not is_teacher:
            raise PermissionDenied("You don't have permission to delete this user from Khatma.")

        khatma_user.delete()

        return Response({'message': 'User deleted from Khatma successfully'})
