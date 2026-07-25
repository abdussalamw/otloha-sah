from django.core.management.base import BaseCommand
from django.db.models import Q
from apps.invitations.models import Invitation, BanedInvitation, BlockList
from apps.users.models import User  # Replace with your actual User model path


class Command(BaseCommand):
    help = "Clean up invalid entries in Invitation, BanedInvitation, and BlockList models."

    def handle(self, *args, **kwargs):
        # Get all valid user IDs
        valid_user_ids = User.objects.values_list('id', flat=True)

        # Remove invalid Invitations
        invalid_invitations = Invitation.objects.filter(
            ~Q(requester__in=valid_user_ids) | ~Q(requestee__in=valid_user_ids)
        )
        invitations_deleted, _ = invalid_invitations.delete()
        self.stdout.write(f"Deleted {invitations_deleted} invalid Invitations.")

        # Remove invalid BanedInvitations
        invalid_baned_invitations = BanedInvitation.objects.filter(
            ~Q(blocker__in=valid_user_ids) | ~Q(blocked__in=valid_user_ids)
        )
        baned_invitations_deleted, _ = invalid_baned_invitations.delete()
        self.stdout.write(f"Deleted {baned_invitations_deleted} invalid BanedInvitations.")

        # Remove invalid BlockLists
        invalid_block_lists = BlockList.objects.filter(
            ~Q(blocker__in=valid_user_ids) | ~Q(blocked__in=valid_user_ids)
        )
        block_lists_deleted, _ = invalid_block_lists.delete()
        self.stdout.write(f"Deleted {block_lists_deleted} invalid BlockLists.")
