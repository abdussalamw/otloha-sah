from dj_accounts.views_api import UserLogoutAPIView
from django.db import transaction
from django.db.models import Q

from django.utils.translation import gettext as _
from rest_framework import status
from rest_framework.generics import ListAPIView, get_object_or_404
from rest_framework.pagination import (
    PageNumberPagination,
)
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.invitations.models import Invitation, BanedInvitation, BlockList
from apps.recitation.serializers import BaseRecitationSerializer
from apps.users.models import TeacherProfile, Teacher, Student, User
from apps.users.notifications import TeacherMarkedAsFavoriteNotification
from apps.users.permissions import IsATeacherPermission, CheckGenderPermission
from apps.users.serializers import RegisterAsATeacherSerializer, UserSerializer


class PostPageNumberPagination(PageNumberPagination):
    page_size = 10


class TeachersListView(ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = UserSerializer
    pagination_class = PostPageNumberPagination

    def get_queryset(self):
        user = self.request.user
        return Teacher.objects.active().filter_by_gender_settings(user).distinct()

    def get_serializer_context(self):
        return {'user': self.request.user}


class StudentListingView(ListAPIView):
    permission_classes = [IsAuthenticated, IsATeacherPermission]
    serializer_class = UserSerializer
    pagination_class = PostPageNumberPagination

    def get_queryset(self):
        return Student.objects.students_of(self.request.user).active()

    def get_serializer_context(self):
        return {'user': self.request.user}


class ProfileAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        if request.user.is_a_teacher:
            serializer = UserSerializer(instance=request.user)
        else:
            serializer = UserSerializer(instance=request.user, context={
                "user": request.user})
        return Response(serializer.data, status=status.HTTP_200_OK)


class UserDetailsView(APIView):
    permission_classes = [
        IsAuthenticated,
        CheckGenderPermission
    ]

    def get(self, request, *args, **kwargs):
        user_id = kwargs.get('user_id', None)
        user = get_object_or_404(User, pk=user_id) if user_id else request.user

        self.check_object_permissions(request, user)

        serializer = UserSerializer(instance=user, context={
            "user": request.user
        }) if user.is_a_teacher else UserSerializer(instance=user)

        return Response(serializer.data, status=status.HTTP_200_OK)


class UserRecitationsAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get_serializer_response(self, queryset):
        serializer = BaseRecitationSerializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def get(self, request, user_id, *args, **kwargs):
        profile = get_object_or_404(User, pk=user_id)
        queryset = profile.recitations.all()
        if request.user == profile.favorite_teacher:
            return self.get_serializer_response(queryset)

        if request.user.gender != profile.gender and not profile.allow_cross_gender_view:
            return Response({
                "message": _("You are not allow to view this section")
            }, status=status.HTTP_403_FORBIDDEN)

        if profile.is_a_teacher:
            queryset = queryset.filter(is_teacher_recitation=True)

        queryset = queryset.filter(is_remarkable=True, show_in_remarkable=True)

        return self.get_serializer_response(queryset)


class RegisterAsTeacherView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        user = request.user
        if TeacherProfile.objects.filter(teacher=user).exists():
            serializer = RegisterAsATeacherSerializer(
                instance=user.teacherprofile,
                data=request.data,
                context={'user': user})
            message = _('Your teacher profile updated successfully!')
        else:
            serializer = RegisterAsATeacherSerializer(
                data=request.data,
                context={'user': user})
            message = _('Your request to be a teacher is sent successfully!')

        if serializer.is_valid():
            serializer.save()
            return Response({'message': message, 'data': serializer.data}, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class MarkAsFavTeacherAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        teacher = get_object_or_404(Teacher, pk=request.data['teacher'])
        if teacher.gender != request.user.gender and not request.user.allow_cross_gender_view and not teacher.allow_cross_gender_view and teacher.gender == Teacher.GENDER_FEMALE:
            return Response({
                'message': _("this teacher is not allowing students from the opposite gender to be his/her student")
            }, status=status.HTTP_200_OK)
        request.user.favorite_teacher = teacher
        request.user.save()
        request.user.notify(TeacherMarkedAsFavoriteNotification, sender=request.user, receivers=teacher)
        return Response({'message': _("You marked teacher as favorite teacher successfully")},
                        status=status.HTTP_200_OK)


class DeleteAccountAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        user = request.user
        with transaction.atomic():
            # Log out the user
            UserLogoutAPIView().post(request, *args, **kwargs)

            # Delete related invitations
            Invitation.objects.filter(
                Q(requester=user.id) | Q(requestee=user.id)
            ).delete()

            # Delete related banned invitations
            BanedInvitation.objects.filter(
                Q(blocker=user.id) | Q(blocked=user.id)
            ).delete()

            # Delete related blocklist entries
            BlockList.objects.filter(
                Q(blocker=user.id) | Q(blocked=user.id)
            ).delete()

            # Delete the user account
            user.delete()

        return Response({"message": _("Account Deleted Successfully!")})
