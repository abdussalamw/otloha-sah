from django.contrib.auth import get_user_model
from rest_framework import serializers

from quran_api_client.models import Narration
from .models import TeacherProfile, TeacherFiles, User, TeacherNarration, Student, TeacherRecitationPricing
from ..recitation.models import Recitation


class BaseUserSerializer(serializers.ModelSerializer):
    profile_image = serializers.SerializerMethodField()
    fullname = serializers.CharField(source='get_full_name')
    level = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = (
            'id', 'username', 'first_name', 'last_name', 'fullname', 'profile_image', 'date_joined', 'gender', 'bio',
            'level', 'rate', 'language', 'is_a_teacher', 'favorite_teacher', 'narration_id',
        )

    def get_profile_image(self, obj):
        return obj.profile_image

    def get_level(self, obj):
        return obj.get_level_text


class TeacherFilesSerializer(serializers.ModelSerializer):
    class Meta:
        model = TeacherFiles
        fields = ('id', 'file_type', 'file')


class TeacherNarrationSerializer(serializers.ModelSerializer):
    is_complete = serializers.SerializerMethodField(read_only=True)
    min_count = serializers.SerializerMethodField(read_only=True)
    recitations_count = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = TeacherNarration
        fields = ("id", "narration", "is_certified", "certified_at", "certification", "is_complete", "min_count",
                  "recitations_count")
        read_only_fields = ('is_certified', "certified_at", "is_complete", "min_count", "recitations_count")

    def get_is_complete(self, obj):
        return obj.is_complete

    def get_recitations_count(self, obj):
        return obj.teacher.recitations.filter(
            is_teacher_recitation=True, narration_id=str(obj.narration_id)
        ).count()

    def get_min_count(self, obj):
        from apps.settings.utils import get_setting
        return get_setting("min_recitation_per_narration_to_get_certified_as_a_teacher_in_narration")


class TeacherProfileSerializer(serializers.ModelSerializer):
    certifications = TeacherNarrationSerializer(read_only=True, source="teachernarration_set", many=True)
    full_name = serializers.SerializerMethodField()

    class Meta:
        model = TeacherProfile
        fields = (
            'full_name', 'teacher_type', 'status', 'education_degree',
            'can_reply_on_every_verse_in_recitation', 'is_active', 'created_at', 'updated_at',
            'certifications')

    def get_full_name(self, obj):
        return obj.teacher.get_full_name


class UserSerializer(serializers.ModelSerializer):
    teacher_profile = TeacherProfileSerializer(read_only=True, source='teacherprofile')
    fullname = serializers.CharField(source='get_full_name')
    has_password = serializers.SerializerMethodField()
    level = serializers.SerializerMethodField()

    class Meta:
        model = get_user_model()
        fields = (
            'id', 'email', 'username', 'fullname', 'first_name', 'last_name', 'email_verified_at', 'birthdate',
            'language', 'phone', 'bio', 'level', 'gender',
            'is_a_teacher', 'recitation_method', 'favorite_teacher', 'profile_image', 'rate',
            'allow_remarkable_recitations_to_public', 'allow_cross_gender_view', 'teacher_profile',
            'has_password', 'phone_verified_at', 'is_blocked'
        )

    def get_has_password(self, obj):
        return obj.has_password

    def get_level(self, obj):
        return obj.get_level_text


class RegisterAsATeacherSerializer(serializers.ModelSerializer):
    certifications = TeacherNarrationSerializer(many=True, source="teachernarration_set", required=False)

    class Meta:
        model = TeacherProfile
        fields = ('education_degree', 'cv', 'teacher_type', 'certifications')

    def save_certifications(self, certifications):
        extra_data = {
            "teacher": self.context['user'],
            "teacherprofile_id": self.context['user'].teacherprofile.id
        }
        teacher_narrations = self.context['user'].teachernarration_set.all()
        teacher_narrations_ids = list(teacher_narrations.values_list('narration', flat=True))

        for certification in certifications:
            if certification['narration'].id in teacher_narrations_ids:
                teacher_narrations.filter(narration=certification['narration']).update(
                    **{**extra_data, **certification})
            else:
                TeacherNarration.objects.create(**{**extra_data, **certification})

    def create(self, validated_data):
        certifications = validated_data.pop('teachernarration_set', None)

        validated_data["teacher"] = self.context['user']
        teacher_profile = TeacherProfile.objects.create(**validated_data)

        teacher = self.context['user']
        teacher.is_a_teacher = True
        teacher.save()

        if certifications:
            self.save_certifications(certifications)

        from apps.settings.models import UserSetting
        UserSetting.objects.collect_missing_settings(teacher)

        return teacher_profile

    def update(self, instance, validated_data):
        if 'teachernarration_set' in validated_data:
            certifications = validated_data.pop('teachernarration_set')
            self.save_certifications(certifications)

        if 'cv' in validated_data:
            instance.cv = validated_data['cv']

        instance.education_degree = validated_data['education_degree']
        instance.teacher_type = validated_data['teacher_type']
        instance.save()

        return instance


# admin serializers

class NarrationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Narration
        fields = ('id', 'name', 'description')


class AdminTeacherNarrationSerializer(TeacherNarrationSerializer):
    narration = NarrationSerializer()


class AdminTeacherProfileSerializer(TeacherProfileSerializer):
    class Meta(TeacherProfileSerializer.Meta):
        fields = TeacherProfileSerializer.Meta.fields + ('cv',)


class AdminUserSerializer(UserSerializer):
    urls = serializers.SerializerMethodField()

    class Meta(UserSerializer.Meta):
        fields = UserSerializer.Meta.fields + ('urls',)

    def get_urls(self, obj):
        urls = {
            "details": obj.get_details_url,
            # "suspend": obj.get_toggle_suspend_url,
        }
        if obj.is_a_teacher:
            urls['edit'] = obj.get_edit_url
        return urls


class ConnectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['from_user_id', 'to_user_id']


class RecitationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Recitation
        fields = ['id', 'owner', 'result', 'evaluated_at', 'created_at', 'verse_ids', 'narration_id', 'chapter_id',
                  'teacher']


class StudentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = ['id', 'full_name', 'rate', 'email', 'username', 'phone', 'gender', 'narration_id']


class TeacherRecitationPricingSerializer(serializers.ModelSerializer):
    class Meta:
        model = TeacherRecitationPricing
        fields = ['id', 'recitation', 'price', 'is_paid', 'created_at', 'paid_at']


class TeacherProfileWithLessInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = TeacherProfile
        fields = ['teacher_type', 'status', 'cv', 'education_degree', 'can_reply_on_every_verse_in_recitation',
                  'is_active']


class TeacherSerializer(serializers.ModelSerializer):
    teacher_profile = TeacherProfileWithLessInfoSerializer(source='teacherprofile')

    class Meta:
        model = User
        fields = [
            'id', 'full_name', 'rate', 'email', 'username', 'phone', 'image', 'birthdate', 'gender', 'teacher_profile',
        ]
