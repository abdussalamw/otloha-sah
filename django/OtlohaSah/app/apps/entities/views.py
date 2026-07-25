from django.contrib.auth import get_user_model
from django.utils.translation import gettext as _
from django_filters.rest_framework import DjangoFilterBackend
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.generics import get_object_or_404, ListAPIView, RetrieveAPIView, CreateAPIView, DestroyAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.entities.filters import EntityUserFilter, EntityFilter
from apps.entities.models import Entity, EntityUserRole
from apps.entities.permissions import IsEntityOwner
from apps.entities.serializers import EntitySerializer, EntityUserRoleSerializer, EntityListSerializer
from apps.invitations import config
from apps.users_profiles.serializers.serializers import UserListSerializer
from apps.users_profiles.views.views_api_v2.views_api_v2 import AnnotationMixin

UserModel = get_user_model()


class EntityListView(ListAPIView, AnnotationMixin):
    permission_classes = [IsAuthenticated]
    serializer_class = EntityListSerializer
    filterset_class = EntityFilter

    @swagger_auto_schema(
        operation_description="List all entities.",
        responses={
            200: "Successful response with a list of entities.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view entities",
            404: "Not Found - entities do not exist",
        }
    )
    def get(self, request, *args, **kwargs):
        invitations_status = {}
        relationships = {}
        if entity_id := request.headers.get('X-Entity-Id', False):
            if not IsEntityOwner().has_permission(request, self):
                return Response(_("You are not the owner of this entity"), status=status.HTTP_422_UNPROCESSABLE_ENTITY)
            invitations_status["out_entity_merge_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_ENTITY_MERGE_REQUEST, entity_id=entity_id, entity_target=True)
            invitations_status["in_entity_merge_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_ENTITY_MERGE_REQUEST, out=False, entity_id=entity_id, entity_target=True)
        else:
            invitations_status["out_join_entity_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_JOIN_ENTITY_REQUEST, entity_target=True)
            invitations_status["in_join_entity_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_JOIN_ENTITY_REQUEST, out=False, entity_target=True)

            relationships["member_in_entity"] = self.get_entity_members_relationship_annotation()

        queryset = Entity.objects.all().unblocked_unblocker_entities(self.request.user).annotate(
            **invitations_status, **relationships)

        queryset = self.filter_queryset(queryset)

        paginator = self.pagination_class()
        paginated_queryset = paginator.paginate_queryset(queryset, request)

        serializer = EntityListSerializer(paginated_queryset, many=True)
        return paginator.get_paginated_response(serializer.data)


class EntityRetrieveView(RetrieveAPIView, AnnotationMixin):
    serializer_class = EntityListSerializer
    permission_classes = [IsAuthenticated]
    lookup_url_kwarg = 'entity_id'
    queryset = Entity.objects.all()

    @swagger_auto_schema(
        operation_description="List details of specific entity.",
        responses={
            200: "Successful response with an entity",
            401: "Unauthorized - The user is Unauthorized",
            404: "Not Found - This entity does not exist",
        }
    )
    def retrieve(self, request, *args, **kwargs):
        invitations_status = {}
        relationships = {}

        if entity_id := request.headers.get('X-Entity-Id', False):
            if not IsEntityOwner().has_permission(request, self):
                return Response(_("You are not the owner of this entity"), status=status.HTTP_422_UNPROCESSABLE_ENTITY)
            invitations_status["out_entity_merge_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_ENTITY_MERGE_REQUEST, entity_id=entity_id, entity_target=True)
            invitations_status["in_entity_merge_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_ENTITY_MERGE_REQUEST, out=False, entity_id=entity_id, entity_target=True)
        else:
            invitations_status["out_join_entity_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_JOIN_ENTITY_REQUEST, entity_id=entity_id, entity_target=True)
            invitations_status["in_join_entity_request"] = self.get_invitation_annotation(
                config.INVITATION_TYPE_JOIN_ENTITY_REQUEST, out=False, entity_id=entity_id, entity_target=True)

            relationships["member_in_entity"] = self.get_entity_members_relationship_annotation()

        entity_with_annotations = (self.queryset.filter(pk=kwargs.get('entity_id'))
                                   .unblocked_unblocker_entities(self.request.user) \
                                   .annotate(**invitations_status, **relationships).first())
        if not entity_with_annotations:
            return Response(_("Not Found"), status=status.HTTP_404_NOT_FOUND)
        serializer = EntityListSerializer(entity_with_annotations)
        return Response(serializer.data)


class EntityCreateView(CreateAPIView):
    serializer_class = EntitySerializer
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(
        operation_description="List details of specific entity.",
        responses={
            200: "Successful response with an entity",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view this entity",
            404: "Not Found - This entity does not exist",
        }
    )
    def post(self, request, *args, **kwargs):
        return super().post(request, *args, **kwargs)


class EntityUpdateView(APIView):
    serializer_class = EntitySerializer
    permission_classes = [IsAuthenticated, IsEntityOwner]

    @swagger_auto_schema(
        operation_description="Update entity.",
        manual_parameters=[
            openapi.Parameter(
                name='X-Entity-Id',
                in_=openapi.IN_HEADER,
                type=openapi.TYPE_STRING,
                required=False,
                description='Add Entity Id here'
            )
        ],
        responses={
            201: "Entity Update successfully",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to Update this entity",
            404: "Not Found - This entity does not exist",
        }, request_body=EntitySerializer,
    )
    def put(self, request, *args, **kwargs):
        entity_id = request.headers.get('X-Entity-Id', None)
        if entity_id is None:
            return Response({'error': 'Entity ID not found in headers.'}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)

        entity = get_object_or_404(Entity, pk=entity_id)
        if entity.entityuserrole_set.filter(role=EntityUserRole.ROLE_CHOICE_OWNER, user=request.user).exists():
            serializer = self.serializer_class(entity, data=request.data)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_203_NON_AUTHORITATIVE_INFORMATION)
        return Response({'error': 'You are not the owner of this entity.'}, status=status.HTTP_403_FORBIDDEN)


class EntityAssignRoleView(APIView):
    permission_classes = [IsAuthenticated, IsEntityOwner]

    @swagger_auto_schema(
        operation_description="Assign role to user.",
        manual_parameters=[
            openapi.Parameter(
                name='X-Entity-Id',
                in_=openapi.IN_HEADER,
                type=openapi.TYPE_STRING,
                required=False,
                description='Add Entity Id here'
            )
        ],
        request_body=EntityUserRoleSerializer,
        responses={
            201: "role assigned successfully",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to assigned entity",
            404: "Not Found - This entity does not exist",
        },
    )
    def post(self, request, *args, **kwargs):
        role = request.data.get('role')
        allowed_roles = list(dict(EntityUserRole.ROLE_CHOICES).keys()) + ['remove']
        if role not in allowed_roles:
            return Response({'error': 'Invalid parameters'}, status=400)
        entity_user_role = request.entity.entityuserrole_set.filter(user=request.data.get("user"))
        if not entity_user_role.exists():
            return Response({'error': _("User is not a member")}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)
        if role in [EntityUserRole.ROLE_CHOICE_OWNER,
                    EntityUserRole.ROLE_CHOICE_MODERATOR] and role in request.entity.entityuserrole_set.filter(
            entity=request.entity).values_list('role', flat=True):
            return Response({'error': _("This role already exist in entity")},
                            status=status.HTTP_422_UNPROCESSABLE_ENTITY)
        entity_user_role = entity_user_role.first()
        if role == 'remove':
            entity_user_role.delete()
            return Response({'success': f'Removed successfully.'})
        entity_user_role.role = role
        entity_user_role.save()
        return Response({'success': f'Role updated successfully.'})


class EntityDestroyView(APIView):
    permission_classes = [IsAuthenticated, IsEntityOwner]

    @swagger_auto_schema(
        manual_parameters=[
            openapi.Parameter(
                name='X-Entity-Id',
                in_=openapi.IN_HEADER,
                type=openapi.TYPE_STRING,
                required=False,
                description='Add Entity Id here'
            )
        ],
        operation_description="Delete entity based on X-Entity-Id header.",
        responses={
            204: "Entity deleted successfully",
            400: "Bad Request - Entity ID not found in headers",
            403: "Forbidden - The user is not authorized to delete this entity",
            404: "Not Found - This entity does not exist",
        }
    )
    def delete(self, request, *args, **kwargs):
        entity_id = request.headers.get('X-Entity-Id')
        if not entity_id:
            return Response({'error': 'Entity ID not found in headers.'}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)

        entity = get_object_or_404(Entity, pk=entity_id)
        self.check_object_permissions(request, entity)
        entity.delete()
        return Response({'message': 'Entity deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)


class EntityUsersView(ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = UserListSerializer
    filterset_class = EntityUserFilter
    filter_backends = [DjangoFilterBackend]

    def get_queryset(self):
        entity = get_object_or_404(Entity, pk=self.kwargs.get('entity_id'))
        users = entity.entityuserrole_set.values_list('user', flat=True).distinct()
        return UserModel.objects.filter(id__in=users)

    @swagger_auto_schema(
        manual_parameters=[
            openapi.Parameter(
                'entity_id',
                openapi.IN_PATH,
                description='ID of the entity',
                type=openapi.TYPE_INTEGER
            ),
        ],
        responses={
            200: openapi.Response('Successful response description', UserListSerializer),
            404: 'Entity not found',
        },
        operation_id='List entity users',
        operation_description='Retrieve a list of users belonging to a specific entity.'
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)


class UserEntitiesListView(ListAPIView):
    serializer_class = EntitySerializer
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(
        operation_description="List my entities.",
        responses={
            200: "Successful response with a list of entities.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view entities",
            404: "Not Found - entities do not exist",
        }
    )
    def list(self, request):
        user_entities = EntityUserRole.objects.filter(user=request.user).values_list('entity', flat=True)
        entities = Entity.objects.filter(id__in=user_entities)
        serializer = self.serializer_class(entities, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class EntityLeaveView(DestroyAPIView):
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(
        operation_description="Leave a specific entity.",
        responses={
            200: "Successful response with an entity",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view this entity",
            404: "Entity user not Found - You are not a member of this entity.",
        }
    )
    def destroy(self, request, *args, **kwargs):
        user = request.user
        entity_id = kwargs.get('entity_id')
        entity_user_role = get_object_or_404(EntityUserRole, user=user, entity_id=entity_id)

        if entity_user_role.role == EntityUserRole.ROLE_CHOICE_OWNER:
            return Response({"detail": "You cannot leave an entity you own."}, status=status.HTTP_403_FORBIDDEN)

        entity_user_role.delete()

        return Response({"detail": "You have left the entity successfully."}, status=status.HTTP_200_OK)
