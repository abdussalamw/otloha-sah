from django.utils.translation import gettext as _
from rest_framework import serializers
from rest_framework.reverse import reverse

from apps.recitation.models import Recitation
from apps.users.models import Teacher, TeacherProfile, TeacherNarration, TeacherRecitationPricing
from quran_api_client.models import Narration, Verse, Chapter


class TeacherListSerializer(serializers.ModelSerializer):
    recitations_statistics = serializers.SerializerMethodField()
    teacher_accounting = serializers.SerializerMethodField()
    actions = serializers.SerializerMethodField()

    class Meta:
        model = Teacher
        fields = (
            'id', 'full_name', 'email', 'is_verified', 'rate', 'recitations_statistics', 'gender', 'image',
            'narration_id', 'is_blocked', 'teacher_accounting', 'actions',
        )

    def get_recitations_statistics(self, obj):
        return {
            'total_recitations': obj.total_recitations,
            'accepted_recitations': obj.accepted_recitations,
            'rejected_recitations': obj.rejected_recitations,
            'reported_recitations': obj.reported_recitations,
            'pending_recitations': obj.pending_recitations,
        }

    def get_teacher_accounting(self, obj):
        return {
            'earnings': round(obj.earnings, 2) if obj.earnings is not None else 0.00,
            'dues': round(obj.dues, 2) if obj.dues is not None else 0.00,
        }

    def get_actions(self, obj):
        actions = []

        if obj.teacherprofile.status in [obj.teacherprofile.STATUS_PENDING, obj.teacherprofile.STATUS_REJECTED]:
            actions.append({
                'text': _("Approve"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action', args=['teacher', obj.pk, 'approve']),
            })

        if obj.teacherprofile.is_active:
            actions.append({
                'text': _("Suspend"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action', args=['teacher', obj.pk, 'suspend']),
            })
        else:
            actions.append({
                'text': _("Unsuspend"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action',
                               args=['teacher', obj.pk, 'unsuspend']),
            })

        if obj.teacherprofile.status == obj.teacherprofile.STATUS_PENDING:
            actions.append({
                'text': _("Reject"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action', args=['teacher', obj.pk, 'reject']),
            })

        if obj.teacherprofile.can_reply_on_every_verse_in_recitation:
            actions.append({
                'text': _("Disable Reply on Every Verse in Recitation"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action',
                               args=['teacher', obj.pk, 'can_reply_on_whole_recitation']),
            })
        else:
            actions.append({
                'text': _("Enable Reply on Every Verse in Recitation"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action',
                               args=['teacher', obj.pk, 'can_reply_on_every_verse_in_recitation']),
            })

        if not obj.is_blocked:
            actions.append({
                'text': _("Block"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action', args=['teacher', obj.pk, 'block']),
            })

        return actions


class TeacherProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = TeacherProfile
        fields = (
            'cv', 'education_degree', 'can_reply_on_every_verse_in_recitation', 'status', 'is_active'
        )

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['cv'] = instance.cv.url if instance.cv else "Not Provided"
        representation['education_degree'] = instance.education_degree if instance.education_degree else "Not Provided"
        representation['can_reply_on_every_verse_in_recitation'] = (
            instance.can_reply_on_every_verse_in_recitation if instance.can_reply_on_every_verse_in_recitation else "Not Provided"
        )
        return representation


class TeacherDetailSerializer(serializers.ModelSerializer):
    is_paid = serializers.SerializerMethodField()
    narration = serializers.SerializerMethodField()
    profile = TeacherProfileSerializer(source='teacherprofile', read_only=True)
    actions = serializers.SerializerMethodField()

    class Meta:
        model = Teacher
        fields = (
            'id', 'full_name', 'email', 'is_verified', 'rate', 'gender', 'image', 'is_paid',
            'narration', 'profile', 'actions',
        )

    def get_narration(self, obj):
        narration = TeacherNarration.objects.filter(teacher=obj).first()
        if narration:
            return narration.narration.name
        return "Not Provided"

    def get_is_paid(self, obj):
        pricing = TeacherRecitationPricing.objects.filter(teacher=obj).first()
        if pricing:
            return pricing.is_paid
        return "Not Provided"

    def get_actions(self, obj):
        actions = []

        if obj.teacherprofile.status in [obj.teacherprofile.STATUS_PENDING, obj.teacherprofile.STATUS_REJECTED]:
            actions.append({
                'text': _("Approve"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action', args=['teacher', obj.pk, 'approve']),
            })

        if obj.teacherprofile.is_active:
            actions.append({
                'text': _("Suspend"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action', args=['teacher', obj.pk, 'suspend']),
            })
        else:
            actions.append({
                'text': _("Unsuspend"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action',
                               args=['teacher', obj.pk, 'unsuspend']),
            })

        if obj.teacherprofile.status == obj.teacherprofile.STATUS_PENDING:
            actions.append({
                'text': _("Reject"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action', args=['teacher', obj.pk, 'reject']),
            })

        if obj.teacherprofile.can_reply_on_every_verse_in_recitation:
            actions.append({
                'text': _("Disable Reply on Every Verse in Recitation"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action',
                               args=['teacher', obj.pk, 'can_reply_on_whole_recitation']),
            })
        else:
            actions.append({
                'text': _("Enable Reply on Every Verse in Recitation"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action',
                               args=['teacher', obj.pk, 'can_reply_on_every_verse_in_recitation']),
            })

        if not obj.is_blocked:
            actions.append({
                'text': _("Block"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action', args=['teacher', obj.pk, 'block']),
            })
        else:
            actions.append({
                'text': _("Unblock"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action',
                               args=['teacher', obj.pk, 'unblock']),
            })

        return actions


class TeacherNarrationSerializer(serializers.ModelSerializer):
    narration = serializers.SerializerMethodField()
    actions = serializers.SerializerMethodField()

    class Meta:
        model = TeacherNarration
        fields = ['id', 'narration', 'is_certified', 'remaining_required_recitations', 'actions']

    def get_narration(self, obj):
        return obj.narration.name

    def get_actions(self, obj):
        actions = []
        if not obj.is_certified:
            actions.append({
                'text': _("Certify"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-certification',
                               args=['teacher', obj.pk, obj.narration_id, 'suspend']),
            })
        else:
            actions.append({
                'text': _("Uncertify"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-certification',
                               args=['teacher', obj.pk, obj.narration_id, 'unsuspend']),
            })
        return actions


class TeacherAccountingSerializer(serializers.ModelSerializer):
    actions = serializers.SerializerMethodField()

    class Meta:
        model = TeacherRecitationPricing
        fields = (
            'id', 'price', 'teacher', 'recitation_name', 'is_paid', 'paid_at', 'created_at', 'actions'
        )

    def get_actions(self, obj):
        actions = []

        if not obj.is_paid:
            actions.append({
                'text': _("Paid"),
                'url': reverse('api-admin-v1:users:actions:toggle-mark-recitation-pricing-as-completed',
                               args=['teacher', obj.teacher.id, obj.pk], )
            })

        return actions


class TeacherRecitationsSerializer(serializers.ModelSerializer):
    actions = serializers.SerializerMethodField()
    narration = serializers.SerializerMethodField()
    from_verse = serializers.SerializerMethodField()
    to_verse = serializers.SerializerMethodField()
    chapter = serializers.SerializerMethodField()
    actions = serializers.SerializerMethodField()

    class Meta:
        model = Recitation
        fields = (
            'id', 'name', 'teacher', 'evaluated_at', 'narration', 'chapter', 'from_verse', 'to_verse', 'created_at',
            'owner_rate', 'result', 'actions'
        )

    def get_actions(self, obj):
        actions = []

        if obj.result == None:
            actions.append({
                'text': _("Reject"),
                'url': reverse('api-admin-v1:users:actions:toggle-correct-recitation',
                               args=['teacher', obj.pk, 'reject'], )
            })
            actions.append({
                'text': _("Accept"),
                'url': reverse('api-admin-v1:users:actions:toggle-correct-recitation',
                               args=['teacher', obj.pk, 'accept'], )
            })
            actions.append({
                'text': _("Report"),
                'url': reverse('api-admin-v1:users:actions:toggle-correct-recitation',
                               args=['teacher', obj.pk, 'report'], )
            })
        return actions

    def get_narration(self, obj):
        return Narration.objects.get(pk=obj.narration_id).name

    def get_chapter(self, obj):
        return Chapter.objects.get(pk=obj.chapter_id).name

    def get_from_verse(self, obj):
        if obj.verse_ids:
            try:
                verse_ids = obj.verse_ids.strip('[]').split(',')
                first_verse_id = int(verse_ids[0])
                first_verse = Verse.objects.filter(narration=obj.narration_id, id=first_verse_id).first()
                if first_verse:
                    return first_verse.text
            except (ValueError, IndexError):
                return None
        return None

    def get_to_verse(self, obj):
        if obj.verse_ids:
            try:
                verse_ids = obj.verse_ids.strip('[]').split(',')
                last_verse_id = int(verse_ids[-1])
                last_verse = Verse.objects.filter(narration=obj.narration_id, id=last_verse_id).first()
                if last_verse:
                    return last_verse.text
            except (ValueError, IndexError):
                return None
        return None
