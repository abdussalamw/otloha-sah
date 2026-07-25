from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.users.profile.serializers import ChangePasswordSerializer, UpdatePhoneNumberSerializer, \
    UpdateEmailSerializer, UpdateUserDataSerializer


class UpdateProfileDataAPIView(APIView):
    """
    An endpoint for changing User Profile Data.
    """
    permission_classes = (IsAuthenticated,)

    def put(self, request, *args, **kwargs):
        serializer = UpdateUserDataSerializer(data=request.data, instance=request.user)
        if serializer.is_valid():
            serializer.save()
            return Response(status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class UpdateEmailAPIView(APIView):
    """
    An endpoint for changing Email.
    """
    permission_classes = (IsAuthenticated,)

    def get_object(self):
        return self.request.user

    def put(self, request, *args, **kwargs):
        self.object = self.get_object()
        serializer = UpdateEmailSerializer(data=request.data, user=self.object)
        if serializer.is_valid():
            serializer.save()
            return Response(status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class UpdatePhoneAPIView(APIView):
    """
    An endpoint for changing Phone.
    """
    permission_classes = (IsAuthenticated,)

    def get_object(self):
        return self.request.user

    def put(self, request, *args, **kwargs):
        self.object = self.get_object()
        serializer = UpdatePhoneNumberSerializer(data=request.data, user=self.object)
        if serializer.is_valid():
            serializer.save()
            return Response(status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class UpdatePasswordAPIview(APIView):
    """
    An endpoint for changing password.
    """
    permission_classes = (IsAuthenticated,)

    def get_object(self):
        return self.request.user

    def put(self, request, *args, **kwargs):
        self.object = self.get_object()
        serializer = ChangePasswordSerializer(data=request.data)

        if serializer.is_valid():
            # Check old password
            old_password = serializer.data.get("password")
            if not self.object.check_password(old_password):
                return Response({"password": ["Wrong password."]},
                                status=status.HTTP_400_BAD_REQUEST)
            # set_password also hashes the password that the user will get
            self.object.set_password(serializer.data.get("new_password"))
            self.object.save()
            return Response(status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)
