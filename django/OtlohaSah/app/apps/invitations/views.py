from django.db.models import Q
from django.utils.translation import gettext_lazy as _
from django_filters.rest_framework import DjangoFilterBackend
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.filters import SearchFilter
from rest_framework.generics import ListAPIView, get_object_or_404
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.entities.models import Entity
from apps.entities.permissions import IsEntityOwner
from apps.invitations import config, invitations_handler
from apps.invitations.models import Invitation, BlockList, BanedInvitation
from apps.invitations.serializers import InvitationSerializer, BlockListSerializer, BanedInvitationSerializer, \
    ResponseInvitationSerializer
from apps.invitations.serializers_profile import InvitationProfileSerializer, BlockListProfileSerializer, \
    BanedInvitationProfileSerializer, InvitationReceivedProfileSerializer
from apps.users.models import User


class InvitationListAPIView(ListAPIView):
    serializer_class = InvitationProfileSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter]
    search_fields = []

    @swagger_auto_schema(
        manual_parameters=[
            openapi.Parameter(
                name='X-Entity-Id',
                in_=openapi.IN_HEADER,
                type=openapi.TYPE_STRING,
                required=False,
                description='Add Entity Id here'
            )
        ]
    )
    def get_queryset(self):
        if self.request.headers.get('X-Entity-Id'):
            requester = self.request.headers.get('X-Entity-Id')
            requester_type = config.INVITATION_USER_TYPE_ENTITY
        else:
            requester = self.request.user.pk
            requester_type = config.INVITATION_USER_TYPE_USER

        queryset = Invitation.objects.filter(requester=requester, requester_type=requester_type).order_by(
            '-created_at').distinct()
        search_query = self.request.query_params.get('search', None)
        if search_query:
            user_qs = User.objects.filter(
                Q(username__icontains=search_query) |
                Q(email__icontains=search_query)
            )
            entity_qs = Entity.objects.filter(
                Q(name__icontains=search_query) |
                Q(email__icontains=search_query)
            )
            queryset = queryset.filter(
                Q(requester_type='user', requester__in=user_qs) |
                Q(requester_type='entity', requester__in=entity_qs) |
                Q(requestee_type='user', requestee__in=user_qs) |
                Q(requestee_type='entity', requestee__in=entity_qs) |
                Q(requestee_type__icontains=search_query)

            )
        return queryset


class RequestInvitationView(APIView):
    serializer_class = InvitationSerializer
    permission_classes = [IsAuthenticated, ]

    @swagger_auto_schema(request_body=InvitationSerializer,
                         manual_parameters=[
                             openapi.Parameter(
                                 name='X-Entity-Id',
                                 in_=openapi.IN_HEADER,
                                 type=openapi.TYPE_STRING,
                                 required=False,
                                 description='Add Entity Id here'
                             )
                         ])
    def post(self, request, *args, **kwargs):
        serializer = InvitationSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


INVITATION_STATUS = {
    'accepted': 1,
    'rejected': 0,
    'deleted': -1,
}


class RespondToInvitationView(APIView):
    serializer_class = ResponseInvitationSerializer
    permission_classes = [IsAuthenticated, ]

    @swagger_auto_schema(request_body=ResponseInvitationSerializer, manual_parameters=[
        openapi.Parameter(
            name='X-Entity-Id',
            in_=openapi.IN_HEADER,
            type=openapi.TYPE_STRING,
            required=False,
            description='Add Entity Id here'
        )
    ])
    def post(self, request, *args, **kwargs):
        pk = kwargs.get('pk')
        invitation = get_object_or_404(Invitation, pk=pk)
        success = False
        message = _('Request unprocessed.')

        requestee = request.user.pk

        if request.headers.get('X-Entity_id'):
            if not IsEntityOwner().has_permission(request, self):
                return Response(_("You are not the owner of this entity"),
                                status=status.HTTP_422_UNPROCESSABLE_ENTITY)
            requestee = request.headers.get('X-Entity_id')

        if INVITATION_STATUS.get(request.data.get("status")) == config.INVITATION_STATUS_DELETED and \
                (invitation.requestee == requestee or invitation.requester == requestee):
            success = True
            message = _('Request processed successfully.')
            invitation.delete()

        else:
            handler = invitations_handler.INVITATION_RESPONSE_HANDLER[invitation.invitation_type](invitation)
            if INVITATION_STATUS.get(request.data.get("status")) == config.INVITATION_STATUS_ACCEPTED:
                success, message = handler.approve(request)

            elif INVITATION_STATUS.get(request.data.get("status")) == config.INVITATION_STATUS_REJECTED:
                success, message = handler.reject(invitation, request, ban=request.data.get("ban"),
                                                  block=request.data.get("block"))
            invitation.delete()

        return Response({"message": message},
                        status=status.HTTP_200_OK if success else status.HTTP_422_UNPROCESSABLE_ENTITY)


class BlockListAPIView(ListAPIView):
    serializer_class = BlockListProfileSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, ]
    filterset_fields = ['id']

    def get_queryset(self):
        if self.request.headers.get('X-Entity-Id'):
            blocker = self.request.headers.get('X-Entity-Id')
            blocker_type = config.INVITATION_USER_TYPE_ENTITY
        else:
            blocker = self.request.user.pk
            blocker_type = config.INVITATION_USER_TYPE_USER

        queryset = BlockList.objects.filter(blocker=blocker, blocker_type=blocker_type).order_by(
            '-created_at').distinct()
        search_query = self.request.query_params.get('search', None)

        if search_query:
            user_qs = User.objects.filter(
                Q(username__icontains=search_query) |
                Q(email__icontains=search_query)
            )
            entity_qs = Entity.objects.filter(
                Q(name__icontains=search_query) |
                Q(email__icontains=search_query)
            )
            queryset = queryset.filter(
                Q(blocked_type='user', blocked__in=user_qs) |
                Q(blocked_type='entity', blocked__in=entity_qs) |
                Q(blocked_type__icontains=search_query)

            )

        return queryset


class BlockListCreateView(APIView):
    serializer_class = BlockListSerializer
    permission_classes = [IsAuthenticated, ]

    @swagger_auto_schema(request_body=BlockListSerializer,
                         manual_parameters=[
                             openapi.Parameter(
                                 name='X-Entity-Id',
                                 in_=openapi.IN_HEADER,
                                 type=openapi.TYPE_STRING,
                                 required=False,
                                 description='Add Entity Id here'
                             )
                         ])
    def post(self, request, *args, **kwargs):
        if request.headers.get('X-Entity-Id'):
            if not IsEntityOwner().has_permission(request, self):
                return Response(_("You are not the owner of this entity"), status=status.HTTP_422_UNPROCESSABLE_ENTITY)

        serializer = BlockListSerializer(data={
            "blocked": request.data.get('blocked'),
            "blocked_type": request.data.get('blocked_type')
        }, context={'request': request})
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class BlockListDeleteView(APIView):
    permission_classes = [IsAuthenticated, ]

    @swagger_auto_schema(manual_parameters=[
        openapi.Parameter(
            name='X-Entity-Id',
            in_=openapi.IN_HEADER,
            type=openapi.TYPE_STRING,
            required=False,
            description='Add Entity Id here'
        )
    ])
    def delete(self, request, pk, *args, **kwargs):
        if request.headers.get('X-Entity-Id'):
            if not IsEntityOwner().has_permission(request, self):
                return Response(_("You are not the owner of this entity"), status=status.HTTP_422_UNPROCESSABLE_ENTITY)

        block = get_object_or_404(BlockList, pk=pk)
        block.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class BanedInvitationListAPIView(ListAPIView):
    serializer_class = BanedInvitationProfileSerializer
    permission_classes = [IsAuthenticated, ]

    def get_queryset(self):
        if self.request.headers.get('X-Entity-Id'):
            blocker = self.request.headers.get('X-Entity-Id')
            blocker_type = config.INVITATION_USER_TYPE_ENTITY
        else:
            blocker = self.request.user.pk
            blocker_type = config.INVITATION_USER_TYPE_USER

        queryset = BanedInvitation.objects.filter(blocker=blocker, blocker_type=blocker_type).order_by(
            '-created_at').distinct()
        search_query = self.request.query_params.get('search', None)

        if search_query:
            user_qs = User.objects.filter(
                Q(username__icontains=search_query) |
                Q(email__icontains=search_query)
            )
            entity_qs = Entity.objects.filter(
                Q(name__icontains=search_query) |
                Q(email__icontains=search_query)
            )
            queryset = queryset.filter(
                Q(blocked_type='user', blocked__in=user_qs) |
                Q(blocked_type='entity', blocked__in=entity_qs) |
                Q(blocked_type__icontains=search_query)
            )

        return queryset


class BanedInvitationCreateView(APIView):
    serializer_class = BanedInvitationSerializer
    permission_classes = [IsAuthenticated, ]

    @swagger_auto_schema(request_body=BanedInvitationSerializer,
                         manual_parameters=[
                             openapi.Parameter(
                                 name='X-Entity-Id',
                                 in_=openapi.IN_HEADER,
                                 type=openapi.TYPE_STRING,
                                 required=False,
                                 description='Add Entity Id here'
                             )
                         ])
    def post(self, request, *args, **kwargs):
        serializer = BanedInvitationSerializer(data={
            "blocked": request.data.get('blocked'),
            "blocked_type": request.data.get('blocked_type'),
            "invitation_type": request.data.get('invitation_type')
        }, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class BanedInvitationDeleteView(APIView):
    serializer_class = BanedInvitationSerializer
    permission_classes = [IsAuthenticated, ]

    @swagger_auto_schema(request_body=BanedInvitationSerializer)
    def delete(self, request, pk, *args, **kwargs):
        block = get_object_or_404(BanedInvitation, pk=pk)
        block.delete()
        return Response(_("Deleted from baned successfully"))


class InvitationReceivedListAPIView(ListAPIView):
    serializer_class = InvitationReceivedProfileSerializer
    permission_classes = [IsAuthenticated]
    filter_backends = [DjangoFilterBackend, SearchFilter]
    search_fields = []

    @swagger_auto_schema(
        manual_parameters=[
            openapi.Parameter(
                name='X-Entity-Id',
                in_=openapi.IN_HEADER,
                type=openapi.TYPE_STRING,
                required=False,
                description='Add Entity Id here'
            )
        ]
    )
    def get_queryset(self):
        if self.request.headers.get('X-Entity-Id'):
            requestee = self.request.headers.get('X-Entity-Id')
            requestee_type = config.INVITATION_USER_TYPE_ENTITY
        else:
            requestee = self.request.user.pk
            requestee_type = config.INVITATION_USER_TYPE_USER

        queryset = Invitation.objects.filter(requestee=requestee, requestee_type=requestee_type).order_by(
            '-created_at').distinct()

        search_query = self.request.query_params.get('search', None)
        if search_query:
            user_qs = User.objects.filter(
                Q(username__icontains=search_query) |
                Q(email__icontains=search_query)
            )
            entity_qs = Entity.objects.filter(
                Q(name__icontains=search_query) |
                Q(email__icontains=search_query)
            )
            queryset = queryset.filter(

                Q(requester_type='user', requester__in=user_qs) |
                Q(requester_type='entity', requester__in=entity_qs) |
                Q(requestee_type='user', requestee__in=user_qs) |
                Q(requestee_type='entity', requestee__in=entity_qs) |
                Q(requester_type__icontains=search_query)

            )
        return queryset
