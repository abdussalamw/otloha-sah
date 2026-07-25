from gettext import gettext as _

from django.contrib.auth import get_user_model
from django.contrib.auth.tokens import default_token_generator
from django.urls import reverse
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken

from apps.authn.serializers import RegisterUserSerializer
from apps.authn.serializers.registeration import VerifyEmailSerializer
from apps.authn.tasks import send_email_verification

UserModel = get_user_model()


# def send_verification(request, user):
#     protocol = "https" if request.is_secure() else "http"
#     app_url = f"{protocol}://{settings.CLIENT_APP_HOST}"
#     uid = urlsafe_base64_encode(force_bytes(user.pk))
#     token = default_token_generator.make_token(user)
#     verification_path = f"verify-email/?uidb64={uid}&token={token}"
#     verification_url = f"{app_url}/{verification_path}"
#     send_email_verification(user.id, app_url, verification_url)

def send_api_email_verification(request, user):
    uid = urlsafe_base64_encode(force_bytes(user.pk))
    token = default_token_generator.make_token(user)
    verification_url = request.build_absolute_uri(
        reverse("api-v2:authentication:email-verification:verify", args=[uid, token])
    )
    app_url = f"{request.scheme}://{request.get_host()}"
    send_email_verification.delay(user.id, app_url, verification_url)


class RegisterAPIView(APIView):
    permission_classes = [AllowAny]

    @swagger_auto_schema(
        request_body=RegisterUserSerializer,
        responses={
            201: "Created",
            422: "Unprocessable Entity",
        },
        operation_summary="User Registration",
        operation_description="Register a new user with the provided username, email, and password."
    )
    def post(self, request):
        """
        Register a new user with the provided data.
        """
        serializer = RegisterUserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            send_api_email_verification(request, user)
            refresh = RefreshToken.for_user(user)
            return Response({"access": str(refresh.access_token), "refresh": str(refresh)
                             }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class SendVerificationEmailAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        if request.user.email_verified_at:
            return Response({"message": _("Email is already verified")}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)

        send_api_email_verification(request, request.user)
        return Response({
            "message": _("We've emailed you the email verification link."
                         " Please go ahead and verify your email to complete the registration process.")})


class VerifyEmailAPIView(APIView):
    permission_classes = [AllowAny]

    @swagger_auto_schema(
        responses={
            200: "OK",
            400: "Bad Request",
        },
        operation_summary="Verify Email",
        operation_description="Verify the user's email using the provided uid and token."
    )
    def post(self, request, uidb64, token):
        """
        Verify the user's email using the provided uidb64 and token.
        """
        serializer = VerifyEmailSerializer(data={"uid": uidb64, "token": token})
        if serializer.is_valid():
            return Response({"message": _('Email was verified successfully.')}, status=status.HTTP_200_OK)
        return Response({"message": _('Something went wrong, please try again!')}, status=status.HTTP_400_BAD_REQUEST)
