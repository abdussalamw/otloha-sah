from rest_framework.generics import ListAPIView
from rest_framework.permissions import IsAuthenticated

from apps.users.admin.views.serializers_admin_api_v1 import UserAdminSerializer
from apps.users.models import User


class UsersListingAdminListAPIView(ListAPIView):
    permission_classes = [IsAuthenticated]
    queryset = User.objects.all()
    serializer_class = UserAdminSerializer
