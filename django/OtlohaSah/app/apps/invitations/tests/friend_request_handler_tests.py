from django.contrib.auth import get_user_model
from django.test import TestCase
from django.utils.translation import gettext as _

from apps.invitations import config
from apps.invitations.invitations_handler import FriendRequestHandler

User = get_user_model()


class FriendRequestHandlerTests(TestCase):
    def setUp(self):
        self.requester = User.objects.get(email="fritill.admin@mail.com")
        self.requestee = User.objects.get(email="rokiaelsaieed@gmail.com")

    def test_invalid_requestee_type(self):
        handler = FriendRequestHandler(request=None)
        data = {
            "requestee": self.requestee,
            "requestee_type": config.INVITATION_USER_TYPE_ENTITY
        }
        result = handler.check(data)
        self.assertFalse(result[0], "Invalid requestee type check failed")
        self.assertEqual(result[1], _("You can't send this request."), "Invalid requestee type error message mismatch")

    def test_already_friends(self):
        # Make requester and requestee friends
        self.requester.connections.add(self.requestee)
        handler = FriendRequestHandler(request=None)
        data = {
            "requestee": self.requestee,
            "requestee_type": config.INVITATION_USER_TYPE_USER
        }
        result = handler.check(data)
        self.assertFalse(result[0], "Already friends check failed")
        self.assertEqual(result[1], _("This user is already a friend"), "Already friends error message mismatch")

    def test_gender_mismatch(self):
        handler = FriendRequestHandler(request=None)
        data = {
            "requestee": self.requestee,
            "requestee_type": config.INVITATION_USER_TYPE_USER
        }
        result = handler.check(data)
        self.assertFalse(result[0], "Gender mismatch check failed")
        self.assertEqual(result[1], _("You can't send this request"), "Gender mismatch error message mismatch")
