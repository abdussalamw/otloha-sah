from rest_framework import permissions
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.users.serializers.user_serializers import ProfileSerializerResponse


class UserDetails(APIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = ProfileSerializerResponse

    def get(self, request, **kwargs):
        serializer = self.serializer_class(request.user)
        return Response(serializer.data)

    # Todo: add permissions here
    # def get(self, request, pk, **kwargs):
    #     if not request.user.pk == pk:
    #         raise PermissionDenied
    #     else:
    #         serializer = self.serializer_class(request.user)
    #         return Response(serializer.data)
    #
