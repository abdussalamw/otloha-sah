from django.contrib.auth import get_user_model, authenticate
from django.utils.translation import gettext as _
from rest_framework import serializers
from rest_framework.exceptions import ValidationError


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=False)
    confirm_password = serializers.CharField(write_only=True, required=False)
    first_name = serializers.CharField(write_only=True, required=True)
    last_name = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = get_user_model()
        fields = ['username', 'email', 'password', 'confirm_password', 'first_name', 'last_name', 'phone']

    def validate(self, attrs):
        if 'password' not in attrs and 'confirm_password' not in attrs:
            raise ValidationError(
                {"password": _("password field is required"),
                 "confirm_password": _("confirm password is required")})

        if 'password' not in attrs:
            raise ValidationError({"password": _("password field is required")})

        if 'confirm_password' not in attrs:
            raise ValidationError({"confirm_password": _("confirm password is required")})

        if attrs['password'] != attrs['confirm_password']:
            raise ValidationError({"confirm_password": _('confirm password does not match password')})

        if 'phone' not in attrs:
            raise ValidationError({"phone": _("phone is required")})

        if get_user_model().objects.filter(phone=attrs['phone']).exists():
            raise ValidationError({"phone": _('phone is already exists Please Enter another Number')})

        return attrs

    def create(self, validated_data):
        validated_data.pop('confirm_password')
        return super(RegisterSerializer, self).create(validated_data)

    def update(self, instance, validated_data):
        try:
            validated_data.pop('confirm_password')
        except:
            pass
        return super(RegisterSerializer, self).update(instance, validated_data)

    def save(self, **kwargs):
        user = super(RegisterSerializer, self).save()
        if 'password' in self.validated_data:
            user.set_password(self.validated_data["password"])
            user.save()
        return user


class LoginSerializer(serializers.ModelSerializer):
    phone = serializers.CharField(write_only=True, required=False)
    username = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = get_user_model()
        fields = ['username', 'password', 'phone']

    def __init__(self, request=None, *args, **kwargs):
        self.request = request
        super(LoginSerializer, self).__init__(*args, **kwargs)

    def validate(self, attrs):
        username = attrs.get('username', None)
        phone = attrs.get('phone', None)
        password = attrs.get('password', None)

        if username is None and phone is None:
            raise ValidationError({"msg": _('You have to login using your Email or phone')})

        if username and phone:
            raise ValidationError({"msg": _('You have to login using your Email or phone')})

        login_by = None
        credentials = {"password": password}

        if phone:
            login_by = phone
            credentials.update({"phone": phone})

        elif username:
            login_by = username
            credentials.update({get_user_model().USERNAME_FIELD: username})

        if login_by and password:
            authenticate(request=self.request, **credentials)

        return attrs

