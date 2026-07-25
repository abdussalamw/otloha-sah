from django.contrib.auth import get_user_model
from django.contrib.auth.tokens import default_token_generator
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_decode
from django.utils.timezone import now
from django.utils.translation import gettext as _
import phonenumbers
from phonenumber_field.serializerfields import PhoneNumberField
from rest_framework import serializers

UserModel = get_user_model()


def unique_phone_number_validator(value):
    if UserModel.objects.filter(phone=value).exists():
        raise serializers.ValidationError(_("Phone number must be unique."))


class RegisterUserSerializer(serializers.ModelSerializer):
    password1 = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)

    phone = PhoneNumberField(write_only=True, required=True, validators=[unique_phone_number_validator])

    errors_map = {
        "password_mismatch": _("The two password fields didn’t match."),
    }

    class Meta:
        model = UserModel
        fields = (
            'username', 'email', 'phone', 'password1', 'password2', 'gender', 'birthdate', 'country')

    def validate(self, data):
        password1 = data.get('password1')
        password2 = data.get('password2')

        if password1 and password2 and password1 != password2:
            raise serializers.ValidationError({
                "password": self.errors_map["password_mismatch"]
            })

        return data

    def validate_country(self, value):
        if phone := self.initial_data.get('phone'):
            parsed_phone = phonenumbers.parse(phone, None)
            country_code = phonenumbers.region_code_for_number(parsed_phone)

            if country_code == 'IL':
                country_code = "PS"
            if country_code == value:
                return value
        raise serializers.ValidationError(_("Wrong country type."))

    def create(self, validated_data):
        password1 = validated_data.pop('password1')
        validated_data.pop('password2')

        user = UserModel.objects.create(**validated_data)
        user.set_password(password1)
        user.save()

        return user


class VerifyEmailSerializer(serializers.Serializer):
    token = serializers.CharField(required=True)
    uid = serializers.CharField(required=True)

    def validate(self, attrs):
        user_id = force_bytes(urlsafe_base64_decode(attrs.get('uid')))
        user = UserModel.objects.get(pk=user_id)
        if not default_token_generator.check_token(user, attrs.get('token')):
            raise serializers.ValidationError({"token": _("Invalid Token")})
        else:
            user.email_verified_at = now()
            user.save()
        return attrs
