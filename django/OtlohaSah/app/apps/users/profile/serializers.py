from django.contrib.auth import get_user_model, authenticate
from django.utils.translation import gettext as _
from rest_framework import serializers
from rest_framework.exceptions import ValidationError


class UpdateProfileSerializer(serializers.ModelSerializer):
    phone = serializers.CharField(required=False)
    email = serializers.EmailField(required=False)

    class Meta:
        model = get_user_model()
        fields = (
            'username', 'first_name', 'last_name', 'full_name', 'gender', 'birthdate', 'image', 'language',
            'allow_remarkable_recitations_to_public', 'bio', 'narration_id',
            'recitation_method', 'allow_cross_gender_view', 'phone', 'email', 'phone_verified_at'
        )


class UpdateEmailSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ['email', 'password']


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
