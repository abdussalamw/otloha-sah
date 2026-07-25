import abc

from django.contrib.auth import get_user_model
from django.db.models import Q
from django.utils.translation import gettext as _

from apps.entities.models import Entity, EntityUserRole
from apps.entities.permissions import IsEntityOwner
from apps.invitations import config
from apps.invitations.models import BlockList, BanedInvitation, Invitation
from apps.invitations.notifications import FriendRequestNotification, SupervisionRequestNotification
from apps.khatma.models import Khatma, KhatmaUsers
from apps.settings.utils import get_user_setting

UserModel = get_user_model()


class BaseRequestHandler(abc.ABC):
    invitation_type = None

    def __init__(self, request):
        self.request = request
        self.requester = request.user
        self.requester_type = config.INVITATION_USER_TYPE_ENTITY if request.headers.get('X-Entity-Id', None) \
            else config.INVITATION_USER_TYPE_USER

    def check(self, data):
        if BlockList.objects.filter(
                Q(blocker=self.requester.pk, blocked=data.get('requestee').pk) |
                Q(blocker=data.get('requestee').pk, blocked=self.requester.pk)).exists():
            return False, _("You can not send this request.")

        if BanedInvitation.objects.filter(
                Q(blocker=self.requester.pk, blocked=data.get('requestee').pk)
                | Q(blocker=data.get('requestee').pk, blocked=self.requester.pk),
                invitation_type=self.invitation_type).exists():
            return False, _("You can not send this request.")

        return True, None

    def save(self, data):
        return Invitation.objects.create(
            requester=self.requester.pk,
            requestee=data.get('requestee').pk,
            requester_type=self.requester_type,
            requestee_type=data.get('requestee_type'),
            invitation_type=self.invitation_type,
        )


class FriendRequestHandler(BaseRequestHandler):
    invitation_type = config.INVITATION_TYPE_FRIEND_REQUEST

    def check(self, data):
        self.requestee = data.get('requestee')
        if self.request.headers.get('X-Entity-Id', None) or data.get(
                'requestee_type') == config.INVITATION_USER_TYPE_ENTITY:
            return False, _("You can't send this request.")

        self.requester_type = config.INVITATION_USER_TYPE_USER
        if self.requester.connections.filter(pk=data.get('requestee').pk).exists() or data.get(
                'requestee').connections.filter(pk=self.requester.pk).exists():
            return False, _("This user is already a friend")

        if self.requester.gender != self.requestee.gender and not all([
            get_user_setting(self.requester, 'display_profile_to_opposite_gender'),
            get_user_setting(self.requestee, 'display_profile_to_opposite_gender'),
        ]):
            return False, _("You can't send this request")
        return super().check(data)

    def save(self, data):
        instance = super().save(data)
        instance.notify(FriendRequestNotification, receivers=data.get('requestee'), sender=self.requester)
        return instance


class JoinKhatmaRequestHandler(BaseRequestHandler):
    invitation_type = config.INVITATION_TYPE_JOIN_KHATMA_REQUEST

    def check(self, data):
        types = [config.INVITATION_USER_TYPE_KHATMA, config.INVITATION_USER_TYPE_USER]
        user_types = [self.requester_type, data.get('requestee_type')]
        if not all([valid_type in user_types for valid_type in types]):
            return False, _("You can't send this request")
        if self.requester_type == config.INVITATION_USER_TYPE_KHATMA:
            khatma = Khatma.objects.get(pk=self.request.headers.get('X-Khatma-Id'))
            self.requester = khatma

            if (data.get('requestee') not in UserModel.objects.filter_by_gender_settings(self.request.user).
                    unblocked_and_unblocker_users(self.request.user)):
                return False, _("You can't send this request")

            if khatma.created_by != self.request.user and \
                    KhatmaUsers.objects.filter(khatma=khatma, user=self.request.user, is_teacher=True).exists():
                return False, _("You don't have the privileges to invite users to join this khatma.")

            if KhatmaUsers.objects.filter(khatma=khatma, user=data.get('requestee')).exists():
                return False, _("This user is already a member of this khatma.")

        elif self.requester_type == config.INVITATION_USER_TYPE_USER:
            khatma = Khatma.objects.get(pk=data.get('requestee').pk)

            if (self.request.user not in UserModel.objects.filter_by_gender_settings(khatma.created_by).
                    unblocked_and_unblocker_users(self.request.user)):
                return False, _("You can't send this request")

            if KhatmaUsers.objects.filter(khatma=khatma, user=self.requester).exists():
                return False, _("You are already a member of this khatma.")
            if khatma.status != config.KHATMA_STATUS_PENDING:
                return False, _("You can't join this khatma.")

        return super().check(data)

    def save(self, data):
        instance = super().save(data)
        # instance.notify(JoinKhatmaRequestNotification, receivers=data.get('requestee'), sender=self.requester)
        return instance


class JoinEntityRequestHandler(BaseRequestHandler):
    invitation_type = config.INVITATION_TYPE_JOIN_ENTITY_REQUEST

    def check(self, data):
        types = [config.INVITATION_USER_TYPE_ENTITY, config.INVITATION_USER_TYPE_USER]
        user_types = [self.requester_type, data.get('requestee_type')]
        if not all([valid_type in user_types for valid_type in types]):
            return False, _("You can't send this request")
        if self.requester_type == config.INVITATION_USER_TYPE_ENTITY:
            entity = Entity.objects.get(pk=self.request.headers.get('X-Entity-Id'))
            self.requester = entity
            if not self.request.user.has_privileges_of_entity(entity):
                return False, _("You don't have the privileges to invite users to join this entity.")
            if EntityUserRole.objects.filter(entity=entity, user=data.get('requestee')).exists():
                return False, _("this user is already a member of this entity.")

        elif self.requester_type == config.INVITATION_USER_TYPE_USER:
            entity = Entity.objects.get(pk=data.get('requestee').pk)

            if EntityUserRole.objects.filter(entity=entity, user=self.requester).exists():
                return False, _("You are already a member of this entity.")

        return super().check(data)

    def save(self, data):
        instance = super().save(data)
        # instance.notify(JoinEntityRequestNotification, receivers=data.get('requestee'), sender=self.requester)
        return instance


class SupervisionRequestHandler(BaseRequestHandler):
    invitation_type = config.INVITATION_TYPE_SUPERVISION_REQUEST

    def check(self, data):
        self.requestee = data.get('requestee')

        if self.request.headers.get('X-Entity-Id', None):
            return False, _("You can't send this request")

        if self.requester.is_a_teacher and self.requestee.is_a_teacher:
            return False, _("You can't send this request")

        student = self.requester if not self.requester.is_a_teacher else self.requestee
        teacher = self.requester if self.requester.is_a_teacher else self.requestee

        if teacher.gender != student.gender and not all([
            get_user_setting(student, 'display_profile_to_opposite_gender'),
            get_user_setting(teacher, 'display_profile_to_opposite_gender'),
        ]):
            return False, _("You can't send this request")

        if student.favorite_teacher and student == self.requester:
            return False, _("You already have a favorite teacher")
        elif student.favorite_teacher and student == self.requestee:
            return False, _("This student already has a favorite teacher")

        return super().check(data)

    def save(self, data):
        instance = super().save(data)
        instance.notify(SupervisionRequestNotification, receivers=data.get('requestee'), sender=self.requester)
        return instance

    def approve(self, request):
        pass

    def reject(self, invitation):
        pass


class MergeRequestHandler(BaseRequestHandler):
    invitation_type = config.INVITATION_TYPE_ENTITY_MERGE_REQUEST

    def check(self, data):
        if not self.request.headers.get('X-Entity-Id'):
            return False, _("You can't send this request")
        try:
            self.requester = Entity.objects.get(pk=self.request.headers.get('X-Entity-Id'))
        except Entity.DoesNotExist:
            return False, _("You are not an entity.")

        try:
            self.requestee = Entity.objects.get(pk=data.get('requestee').pk)
        except Entity.DoesNotExist:
            return False, _("You should send a request to entity.")

        if not self.request.user.is_owner_of_entity(self.requester):
            return False, _("You don't have the privileges to merge entities.")

        return super().check(data)

    def save(self, data):
        instance = super().save(data)
        # instance.notify(MergeRequestNotification, receivers=data.get('requestee'), sender=self.requester)
        return instance


INVITATION_REQUEST_HANDLER = {
    config.INVITATION_TYPE_FRIEND_REQUEST: FriendRequestHandler,
    config.INVITATION_TYPE_SUPERVISION_REQUEST: SupervisionRequestHandler,
    config.INVITATION_TYPE_JOIN_ENTITY_REQUEST: JoinEntityRequestHandler,
    config.INVITATION_TYPE_JOIN_KHATMA_REQUEST: JoinKhatmaRequestHandler,
    config.INVITATION_TYPE_ENTITY_MERGE_REQUEST: MergeRequestHandler,
}


class BaseResponseHandler:
    def __init__(self, invitation, *args, **kwargs):
        self.invitation = invitation
        self.requester = self.get_actor(invitation.requester_type, invitation.requester)
        self.requestee = self.get_actor(invitation.requestee_type, invitation.requestee)

    def get_actor(self, actor_type, actor_id):
        if actor_type == config.INVITATION_USER_TYPE_ENTITY:
            actor = Entity.objects.get(pk=actor_id)
        elif actor_type == config.INVITATION_USER_TYPE_USER:
            actor = UserModel.objects.get(pk=actor_id)
        elif actor_type == config.INVITATION_USER_TYPE_KHATMA:
            actor = Khatma.objects.get(pk=actor_id)
        else:
            raise _("Invalid Type")
        return actor

    def approve(self, request):
        if not self.has_permission_to_response(request):
            return False, _("You don't have the privileges to response this request.")
        return True, _('Request processed successfully.')

    def has_permission_to_response(self, request):
        return request.user.pk == self.invitation.requestee

    def reject(self, invitation, request, ban=False, block=False):
        if not self.has_permission_to_response(request):
            return False, _("You don't have the privileges to response this request.")

        if ban:
            BanedInvitation.objects.create(
                blocker=self.requester.pk,
                blocker_type=self.invitation.requester_type,
                blocked=self.invitation.requestee,
                blocked_type=self.invitation.requestee_type,
                invitation_type=self.invitation.invitation_type)
        if block:
            BlockList.objects.create(
                blocker=self.requester.pk,
                blocker_type=self.invitation.requester_type,
                blocked=self.invitation.requestee,
                blocked_type=self.invitation.requestee_type)
        self.invitation.status = config.INVITATION_STATUS_REJECTED
        self.invitation.save()
        return True, _("Request processed successfully.")


class FriendResponseHandler(BaseResponseHandler):
    def approve(self, request):
        success, message = super().approve(request)
        if not success:
            return success, message
        self.requester.connections.add(self.invitation.requestee)
        return success, message


class JoinEntityResponseHandler(BaseResponseHandler):

    def has_permission_to_response(self, request):
        if self.invitation.requestee_type == config.INVITATION_USER_TYPE_ENTITY:
            responser = EntityUserRole.objects.get(role=config.ROLE_CHOICE_OWNER,
                                                   entity=self.invitation.requestee).user
        else:
            responser = self.invitation.requestee
        return request.user == responser

    def approve(self, request):
        success, message = super().approve(request)
        if not success:
            return success, message
        if self.invitation.requester_type == config.INVITATION_USER_TYPE_ENTITY:
            entity = self.invitation.requester
            user = self.invitation.requestee
            message = _('You are already member in this entity.')
        else:
            entity = self.invitation.requestee
            user = self.invitation.requester
            user = UserModel.objects.get(pk=user)
            entity = Entity.objects.get(pk=entity)
            message = _('This user already member in your entity.')
        if not EntityUserRole.objects.filter(entity=entity, user=user).exists():
            EntityUserRole.objects.create(entity=entity, user=user)
            return True, _('Request processed successfully.')
        return False, message


class JoinKhatmaResponseHandler(BaseResponseHandler):
    def has_permission_to_response(self, request):
        responser = None
        if self.invitation.requestee_type == config.INVITATION_USER_TYPE_KHATMA:
            khatma = self.invitation.requestee
            khatma = Khatma.objects.get(pk=khatma)

            if KhatmaUsers.objects.filter(is_teacher=True, khatma=khatma, user=request.user).exists():
                responser = request.user
        return request.user == responser

    def approve(self, request):
        success, message = super().approve(request)
        if not success:
            return success, message
        if self.invitation.requester_type == config.INVITATION_USER_TYPE_KHATMA:
            khatma = self.invitation.requester
            user = self.invitation.requestee
            message = _('You are already member in this khatma.')
        else:
            khatma = self.invitation.requestee
            user = self.invitation.requester
            message = _('This user already member in your khatma.')
        user = UserModel.objects.get(pk=user)
        khatma = Khatma.objects.get(pk=khatma)
        if not KhatmaUsers.objects.filter(khatma=khatma, user=user).exists():
            KhatmaUsers.objects.create(khatma=khatma, user=user, is_teacher=user.is_a_teacher)
            if user.is_a_teacher:
                Khatma.objects.update(khatma=khatma, active=True)
            return True, _('Request processed successfully.')

        if KhatmaUsers.objects.filter(khatma=khatma).count() > 19:
            khatma.status = config.KHATMA_STATUS_COMPLETED
            khatma.save()
        return False, message


class SupervisionResponseHandler(BaseResponseHandler):
    def approve(self, request):
        success, message = super().approve(request)
        if success and self.invitation.invitation_type == config.INVITATION_TYPE_SUPERVISION_REQUEST:
            requestee = request.user
            requester = UserModel.objects.get(pk=self.invitation.requester)
            student = requester if requestee.is_a_teacher else requestee
            teacher = requester if requester.is_a_teacher else requestee

            student.favorite_teacher = teacher
            student.save()
        return success, message


class MergeResponseHandler(BaseResponseHandler):
    permission_classes = [IsEntityOwner]

    def has_permission_to_response(self, request):
        return request.user == EntityUserRole.objects.get(role=config.ROLE_CHOICE_OWNER,
                                                          entity=self.invitation.requestee).user

    def approve(self, request):
        success, message = super().approve(request)
        if not success:
            return success, message
        users_block_entity = BlockList.objects.filter(
            Q(blocker=self.invitation.requester, blocked=self.invitation.requestee) | \
            Q(blocker=self.invitation.requestee, blocked=self.invitation.requester))

        blocked_user_ids = [block.user_id for block in users_block_entity]
        EntityUserRole.objects.filter(entity_id=self.invitation.requestee, user_id__in=blocked_user_ids).delete()
        entity_users = EntityUserRole.objects.filter(entity_id=self.invitation.requestee)
        entity_users.update(entity_id=self.invitation.requester, role=config.ROLE_CHOICE_USER)
        return success, message


INVITATION_RESPONSE_HANDLER = {
    config.INVITATION_TYPE_FRIEND_REQUEST: FriendResponseHandler,
    config.INVITATION_TYPE_JOIN_ENTITY_REQUEST: JoinEntityResponseHandler,
    config.INVITATION_TYPE_JOIN_KHATMA_REQUEST: JoinKhatmaResponseHandler,
    config.INVITATION_TYPE_SUPERVISION_REQUEST: SupervisionResponseHandler,
    config.INVITATION_TYPE_ENTITY_MERGE_REQUEST: MergeResponseHandler,
}
