from django.db.models import Q, Subquery, OuterRef, Count, IntegerField
from django.utils.translation import gettext as _
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.generics import ListAPIView, get_object_or_404, RetrieveAPIView, DestroyAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.entities.models import EntityUserRole
from apps.entities.permissions import IsEntityOwner
from apps.invitations import config
from apps.invitations.models import Invitation
from apps.users.models import User, Student, Teacher
from apps.users_profiles.filters.filters_api_v2 import UserFilter
from apps.users_profiles.serializers.serializers import TeacherListSerializer, StudentListSerializer, \
    FriendListSerializer, TeacherDetailsSerializer, TeacherProfileDetailsSerializer, StudentProfileDetailsSerializer, \
    StudentDetailsSerializer


class AnnotationMixin(APIView):

    def get_invitation_annotation(self, invitation_type, entity_id=None, out=True, entity_target=False):
        actor = entity_id if entity_id else self.request.user.pk
        actor_type = config.INVITATION_USER_TYPE_ENTITY if entity_id else config.INVITATION_USER_TYPE_USER

        if out:
            subquery_filter = {
                'invitation_type': invitation_type,
                'requester': actor,
                'requester_type': actor_type,
                'requestee': OuterRef('pk'),
                'requestee_type': config.INVITATION_USER_TYPE_USER if not entity_target else config.INVITATION_USER_TYPE_ENTITY
            }
        else:
            subquery_filter = {
                'invitation_type': invitation_type,
                'requestee': actor,
                'requestee_type': actor_type,
                'requester': OuterRef('pk'),
                'requester_type': config.INVITATION_USER_TYPE_USER if not entity_target else config.INVITATION_USER_TYPE_ENTITY
            }

        subquery = Invitation.objects.filter(**subquery_filter).order_by('pk').values('pk')[:1]

        return Subquery(subquery, output_field=IntegerField())

    def get_member_in_entity_relationship_annotation(self, entity_id):
        subquery = EntityUserRole.objects.filter(entity_id=entity_id, user_id=OuterRef('pk'))
        return Subquery(subquery.values('pk').annotate(count=Count('*')).values('count'), output_field=IntegerField())

    def get_entity_members_relationship_annotation(self, ):
        subquery = EntityUserRole.objects.filter(user_id=self.request.user, entity_id=OuterRef('pk'))
        return Subquery(subquery.values('pk').annotate(count=Count('*')).values('count'), output_field=IntegerField())

    def get_supervision_relationship_annotation(self):

        subquery = User.objects.filter(
            Q(favorite_teacher_id=self.request.user.pk, pk=OuterRef('pk')) |
            Q(pk=self.request.user.pk, favorite_teacher_id=OuterRef('pk'))
        )
        return Subquery(subquery.values('pk').annotate(count=Count('*')).values('count'), output_field=IntegerField())

    def get_friend_relationship_annotation(self):
        queryset = self.request.user.connections.all()
        users = User.objects.filter(id__in=Subquery(queryset.values('id')))
        subquery = users.filter(id=OuterRef('pk'))
        return Subquery(subquery.values('pk').annotate(count=Count('*')).values('count'), output_field=IntegerField())


class StudentsAPIView(ListAPIView, AnnotationMixin):
    permission_classes = [IsAuthenticated]
    serializer_class = StudentListSerializer
    filterset_class = UserFilter

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter(
            name='X-Entity-Id',
            in_=openapi.IN_HEADER,
            type=openapi.TYPE_STRING,
            required=False,
            description='Add Entity Id here'
        )
    ], responses={
        200: "Successful response.",
        400: "Bad request.",
        404: "Not found.",
        422: "Unprocessable entity."
    })
    def get(self, request, *args, **kwargs):
        invitations_status = {}
        relationships = {}
        if entity_id := request.headers.get('X-Entity-Id', False):
            if not IsEntityOwner().has_permission(request, self):
                return Response(_("You are not the owner of this entity"), status=status.HTTP_422_UNPROCESSABLE_ENTITY)

            invitations_status["out_join_entity_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_JOIN_ENTITY_REQUEST, entity_id=entity_id, entity_target=False)
            invitations_status["in_join_entity_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_JOIN_ENTITY_REQUEST, out=False, entity_id=entity_id, entity_target=False)

            relationships["member_in_entity"] = self.get_member_in_entity_relationship_annotation(entity_id=entity_id)

        elif request.user.is_a_teacher:
            invitations_status["out_friend_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_FRIEND_REQUEST)
            invitations_status["in_friend_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_FRIEND_REQUEST, out=False)
            invitations_status["out_supervision_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_SUPERVISION_REQUEST)
            invitations_status["in_supervision_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_SUPERVISION_REQUEST, out=False)
            relationships["supervision"] = self.get_supervision_relationship_annotation()
            relationships["friend"] = self.get_friend_relationship_annotation()

        else:
            invitations_status["out_friend_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_FRIEND_REQUEST)
            invitations_status["in_friend_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_FRIEND_REQUEST, out=False)

            relationships["friend"] = self.get_friend_relationship_annotation()

        if 'my-profile' in request.path:
            queryset = Student.objects.students_of(self.request.user).annotate(**invitations_status, **relationships)
        else:
            queryset = Student.objects.unblocked_and_unblocker_users(
                self.request.user).filter_by_gender_settings(self.request.user).annotate(**invitations_status,
                                                                                         **relationships)
        queryset = self.filter_queryset(queryset)

        paginator = self.pagination_class()
        paginated_queryset = paginator.paginate_queryset(queryset, request)

        serializer = self.get_serializer(paginated_queryset, many=True, context={'request': request})

        return paginator.get_paginated_response(serializer.data)


class FriendsListAPIView(ListAPIView, AnnotationMixin):
    permission_classes = [IsAuthenticated]
    serializer_class = FriendListSerializer
    filterset_class = UserFilter

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter(
            name='X-Entity-Id',
            in_=openapi.IN_HEADER,
            type=openapi.TYPE_STRING,
            required=False,
            description='Add Entity Id here'
        )
    ], responses={
        200: "Successful response.",
        400: "Bad request.",
        404: "Not found.",
        422: "Unprocessable entity."
    })
    def get(self, request, *args, **kwargs):
        if request.headers.get('X-Entity-Id', False):
            return Response(status=status.HTTP_404_NOT_FOUND)
        invitations_status = {}
        relationships = {}

        queryset = self.request.user.connections.all().annotate(**invitations_status, **relationships)

        invitations_status["out_supervision_request"] = self.get_invitation_annotation(
            config.INVITATION_TYPE_SUPERVISION_REQUEST)
        invitations_status["in_supervision_request"] = self.get_invitation_annotation(
            config.INVITATION_TYPE_SUPERVISION_REQUEST, out=False)

        relationships["supervision"] = self.get_supervision_relationship_annotation()
        queryset = self.filter_queryset(queryset)
        paginator = self.pagination_class()
        paginated_queryset = paginator.paginate_queryset(queryset, request)

        serializer = FriendListSerializer(paginated_queryset, many=True, context={'request': request})
        return paginator.get_paginated_response(serializer.data)


class TeachersListAPIView(ListAPIView, AnnotationMixin):
    serializer_class = TeacherListSerializer
    filterset_class = UserFilter
    permission_classes = [IsAuthenticated, ]

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter(
            name='X-Entity-Id',
            in_=openapi.IN_HEADER,
            type=openapi.TYPE_STRING,
            required=False,
            description='Add Entity Id here'
        )
    ], responses={
        200: "Successful response.",
        400: "Bad request.",
        404: "Not found.",
        422: "Unprocessable entity."
    })
    def get(self, request, *args, **kwargs):
        invitations_status = {}
        relationships = {}
        if entity_id := request.headers.get('X-Entity-Id', False):
            if not IsEntityOwner().has_permission(request, self):
                return Response(_("You are not the owner of this entity"), status=status.HTTP_422_UNPROCESSABLE_ENTITY)

            invitations_status["out_join_entity_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_JOIN_ENTITY_REQUEST, entity_id=entity_id, entity_target=False)
            invitations_status["in_join_entity_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_JOIN_ENTITY_REQUEST, out=False, entity_id=entity_id, entity_target=False)

            relationships["member_in_entity"] = self.get_member_in_entity_relationship_annotation(entity_id=entity_id)

        elif request.user.is_a_teacher:
            invitations_status["out_friend_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_FRIEND_REQUEST)
            invitations_status["in_friend_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_FRIEND_REQUEST, out=False)
            relationships["friend"] = self.get_friend_relationship_annotation()

        else:
            invitations_status["out_friend_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_FRIEND_REQUEST)
            invitations_status["in_friend_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_FRIEND_REQUEST, out=False)
            invitations_status["out_supervision_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_SUPERVISION_REQUEST)
            invitations_status["in_supervision_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_SUPERVISION_REQUEST, out=False)

            relationships["supervision"] = self.get_supervision_relationship_annotation()
            relationships["friend"] = self.get_friend_relationship_annotation()

        queryset = Teacher.objects.unblocked_and_unblocker_users(
            self.request.user).filter_by_gender_settings(self.request.user).prefetch_related('teachernarration_set')

        queryset = self.filter_queryset(queryset).annotate(**invitations_status, **relationships)
        paginator = self.pagination_class()
        paginated_queryset = paginator.paginate_queryset(queryset, request)
        serializer = TeacherListSerializer(paginated_queryset, many=True, context={'request': request})
        return paginator.get_paginated_response(serializer.data)


class UserDetailsView(RetrieveAPIView, AnnotationMixin):
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter(
            name='X-Entity-Id',
            in_=openapi.IN_HEADER,
            type=openapi.TYPE_STRING,
            required=False,
            description='Add Entity Id here'
        )
    ], responses={
        200: "Successful response.",
        400: "Bad request.",
        404: "Not found.",
        422: "Unprocessable entity."
    })
    def get(self, request, *args, **kwargs):
        invitations_status = {}
        relationships = {}
        if entity_id := request.headers.get('X-Entity-Id', False):
            if not IsEntityOwner().has_permission(request, self):
                return Response(_("You are not the owner of this entity"), status=status.HTTP_422_UNPROCESSABLE_ENTITY)

            invitations_status["out_join_entity_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_JOIN_ENTITY_REQUEST, entity_id=entity_id, entity_target=False)
            invitations_status["in_join_entity_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_JOIN_ENTITY_REQUEST, out=False, entity_id=entity_id, entity_target=False)

            relationships["member_in_entity"] = self.get_member_in_entity_relationship_annotation(entity_id=entity_id)

        else:
            invitations_status["out_friend_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_FRIEND_REQUEST)
            invitations_status["in_friend_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_FRIEND_REQUEST, out=False)
            invitations_status["out_supervision_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_SUPERVISION_REQUEST)
            invitations_status["in_supervision_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_SUPERVISION_REQUEST, out=False)
            relationships["supervision"] = self.get_supervision_relationship_annotation()
            relationships["friend"] = self.get_friend_relationship_annotation()

        queryset = (User.objects.unblocked_and_unblocker_users(self.request.user).
                    filter_by_gender_settings(self.request.user).annotate(**invitations_status, **relationships))

        user = get_object_or_404(queryset, pk=kwargs['pk'])
        serializer_class = self.get_serializer_class()
        serializer = serializer_class(user, context={'request': request})
        return Response(serializer.data)

    def get_serializer_class(self):
        user = get_object_or_404(User, pk=self.kwargs.get('pk'))
        return TeacherProfileDetailsSerializer if user.is_a_teacher else StudentProfileDetailsSerializer


class UnfriendUserView(DestroyAPIView):
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(
        responses={
            204: "No content. The user has been successfully unfriended.",
            401: "Unauthorized. Authentication credentials were not provided.",
            403: "Forbidden. The user does not have permission to access this resource.",
            404: "Not found. The friend to be unfriended does not exist."
        }
    )
    def destroy(self, request, *args, **kwargs):
        friend = get_object_or_404(User, pk=kwargs.get('friend_id'))
        request.user.connections.remove(friend)
        return Response(status=status.HTTP_204_NO_CONTENT)


class MyProfileAPIView(ListAPIView):
    permission_classes = [IsAuthenticated]

    def get_serializer_class(self):
        return TeacherDetailsSerializer if self.request.user.is_a_teacher else StudentDetailsSerializer

    @swagger_auto_schema(
        security=[],
        responses={
            200: "Successful response.",
            401: "Unauthorized. Authentication credentials were not provided.",
            403: "Forbidden. The user does not have permission to access this resource."
        }
    )
    def get(self, request, *args, **kwargs):
        queryset = User.objects.get(pk=self.request.user.pk)

        serializer_class = self.get_serializer_class()
        serializer = serializer_class(queryset, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)


class RemoveFavoriteTeacherView(APIView):
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(
        security=[],
        responses={
            200: "Favorite teacher removed successfully.",
            400: "Bad request. You do not have a favorite teacher.",
            401: "Unauthorized. Authentication credentials were not provided.",
            403: "Forbidden. The user does not have permission to access this resource."
        }
    )
    def delete(self, request, *args, **kwargs):
        if request.user.favorite_teacher:
            request.user.favorite_teacher = None
            request.user.save()
            return Response({"message": "Favorite teacher removed successfully."}, status=status.HTTP_200_OK)
        return Response({"error": "You do not have a favorite teacher."}, status=status.HTTP_400_BAD_REQUEST)
