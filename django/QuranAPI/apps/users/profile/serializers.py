from django.contrib.auth import get_user_model, authenticate
from django.contrib.auth.password_validation import validate_password
from django.utils.translation import gettext as _
from rest_framework import serializers
from rest_framework.exceptions import ValidationError


class UpdateUserDataSerializer(serializers.ModelSerializer):

    class Meta:
        model = get_user_model()
        fields = ['first_name', 'last_name', 'gender', 'birth_date', 'image']


class UpdateEmailSerializer(serializers.ModelSerializer):

    class Meta:
        model = get_user_model()
        fields = ['email', 'password']

    def __init__(self, request=None, user=None, *args, **kwargs):
        self.request = request
        self.user = user
        super(UpdateEmailSerializer, self).__init__(*args, **kwargs)


    def validate(self, attrs):
        password = attrs.get('password', None)
        email = self.user.email

        if 'password' not in attrs:
            raise ValidationError({"password": _("password field is required")})

        if 'email' not in attrs:
            raise ValidationError({"email": _("email is required")})

        if get_user_model().objects.filter(email=attrs['email']).exists():
            raise ValidationError("Email already exists", code="unique")

        credentials = {"password": password}
        credentials.update({"email": email})

        if email and password:
            authenticate(request=self.request, **credentials)

        return attrs

    def create(self, validated_data):
        return super(UpdateEmailSerializer, self).create(validated_data)


class UpdatePhoneNumberSerializer(serializers.ModelSerializer):

    class Meta:
        model = get_user_model()
        fields = ['phone', 'password']

    def __init__(self, request=None, user=None, *args, **kwargs):
        self.request = request
        self.user = user
        super(UpdatePhoneNumberSerializer, self).__init__(*args, **kwargs)

    def validate(self, attrs):
        password = attrs.get('password', None)
        phone = self.user.phone

        if 'password' not in attrs:
            raise ValidationError({"password": _("password field is required")})

        if 'phone' not in attrs:
            raise ValidationError({"email": _("email is required")})

        if get_user_model().objects.filter(phone=attrs['phone']).exists():
            raise ValidationError("Phone already exists", code="unique")

        credentials = {"password": password}
        credentials.update({"phone": phone})

        if phone and password:
            authenticate(request=self.request, **credentials)

        return attrs


class ChangePasswordSerializer(serializers.ModelSerializer):
    """
    Serializer for password change endpoint.
    """
    new_password = serializers.CharField(required=True, write_only=True, max_length=50)

    class Meta:
        model = get_user_model()
        fields = ['password', 'new_password']

    def validate_new_password(self, value):
        validate_password(value)
        return value
