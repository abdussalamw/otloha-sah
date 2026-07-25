from django.utils.translation import gettext as _
from rest_framework import serializers
from rest_framework.reverse import reverse

from apps.recitations.models import Recitation
from apps.recitations.config import RECITATIONS_RESULT
from apps.recitations.models.report import UserRecitationReport, ReportReason
from apps.records.models import Record
from apps.records.serializers import RecordField
from apps.users.models import User




class UserListSerializer(serializers.ModelSerializer):
    fullname = serializers.CharField(source='get_full_name')
    image = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'fullname', 'image', 'is_a_teacher', 'gender']

    def get_image(self, obj):
        return self.context['request'].build_absolute_uri(obj.profile_image)


class BaseRecitationSerializer(serializers.ModelSerializer):
    record = RecordField(queryset=Record.objects.all(), required=True)
    owner = UserListSerializer()
    teacher = UserListSerializer()
    result = serializers.SerializerMethodField()

    class Meta:
        model = Recitation
        fields = [
            'id', 'created_at', 'evaluating', 'evaluated_at', 'teacher_rate', 'owner_rate', 'is_remarkable', 'record',
            'verses',
            'chapter', 'narration', 'name', 'tajweed_lesson_example', 'khatma', 'result',
            'teacher', 'owner', 'is_teacher_recitation', 'updated_at', 'archived_at',
            'show_in_remarkable', 'is_closed', 'closed_at']

    def get_result(self, obj):
        result_map = dict(RECITATIONS_RESULT)
        return result_map.get(obj.result, _("Unknown"))


class TeacherRecitationSerializer(BaseRecitationSerializer):
    class Meta(BaseRecitationSerializer.Meta):
        fields = ['id', 'created_at', 'is_remarkable',
                  'record',
                  'verses',
                  'chapter', 'narration', 'name', 'tajweed_lesson_example', 'khatma',
                  'owner', 'is_teacher_recitation', 'updated_at', 'archived_at',
                  'show_in_remarkable']


class GeneralRecitationSerializer(BaseRecitationSerializer):
    can_pull = serializers.SerializerMethodField()

    class Meta(BaseRecitationSerializer.Meta):
        fields = BaseRecitationSerializer.Meta.fields + ['can_pull']

    def get_can_pull(self, obj):
        user = self.context['user']
        certified_narrations = user.teachernarration_set.filter(is_certified=True).values_list('narration_id',
                                                                                               flat=True)
        return user.is_a_teacher and certified_narrations and obj.narration_id in certified_narrations and \
            not obj.evaluating or user.is_superuser


class KhatmaRecitationSerializer(BaseRecitationSerializer):
    class Meta(BaseRecitationSerializer.Meta):
        fields = ['id', 'created_at', 'evaluating', 'evaluated_at', 'owner_rate', 'is_remarkable', 'record', 'verses',
                  'chapter', 'narration', 'name', 'result', 'teacher_rate', 'owner', 'updated_at', 'archived_at',
                  'show_in_remarkable']


class UserRecitationListSerializer(BaseRecitationSerializer):
    class Meta(BaseRecitationSerializer.Meta):
        model = Recitation
        fields = ['id', 'created_at', 'evaluating', 'evaluated_at', 'owner_rate', 'is_remarkable', 'record', 'verses',
                  'chapter', 'narration', 'name', 'result', 'teacher_rate', 'owner', 'updated_at', 'archived_at',
                  'show_in_remarkable']


class UserRecitationReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserRecitationReport
        fields = ['id', 'reason_text']

    def validate(self, data):
        recitation = self.context.get('recitation')
        reporter = self.context['request'].user
        reportee = recitation.owner if reporter == recitation.teacher else recitation.teacher
        if UserRecitationReport.objects.filter(reporter=reporter, reportee=reportee, recitation=recitation).exists():
            raise serializers.ValidationError("This report already exists.")
        allowed_users = [recitation.owner, recitation.teacher]
        request_users = [reporter, reportee]
        if not all([user in allowed_users for user in request_users]):
            raise serializers.ValidationError("You cannot send this request.")
        return data

    def save(self, **kwargs):
        recitation = self.context.get('recitation')
        reporter = self.context['request'].user
        reportee = recitation.owner if reporter == recitation.teacher else recitation.teacher

        reason_text = self.validated_data.get('reason_text')
        if reason_text is None:
            raise serializers.ValidationError(_({"reason_text": "This field is required."}))
        if reporter == reportee:
            raise serializers.ValidationError(_("reportee should not equal reporter "))

        kwargs.update({
            'recitation': recitation,
            'reporter': reporter,
            'reportee': reportee,
            'reason_text': reason_text
        })

        return super().save(**kwargs)


class ReportedRecitationsSerializer(serializers.ModelSerializer):
    reporter_data = serializers.SerializerMethodField()
    reportee_data = serializers.SerializerMethodField()
    report_reason = serializers.SerializerMethodField()

    class Meta:
        model = Recitation
        fields = ['id', 'owner', 'created_at', 'record', 'verses', 'chapter', 'narration', 'reporter_data',
                  'reportee_data', 'report_reason']

    def get_reporter_data(self, obj):
        report = UserRecitationReport.objects.filter(recitation=obj).first()
        if report:
            serializer = UserListSerializer(report.reporter, context=self.context)
            return serializer.data
        return None

    def get_reportee_data(self, obj):
        report = UserRecitationReport.objects.filter(recitation=obj).first()
        if report:
            serializer = UserListSerializer(report.reportee, context=self.context)
            return serializer.data
        return None

    def get_report_reason(self, obj):
        report = UserRecitationReport.objects.filter(recitation=obj).first()
        if report:
            return report.reason.reason
        return None


class AdminReportedRecitationsSerializer(serializers.ModelSerializer):
    reports = serializers.SerializerMethodField()
    actions = serializers.SerializerMethodField()

    class Meta:
        model = Recitation
        fields = ['id', 'owner', 'created_at', 'record', 'verses', 'chapter', 'narration', 'reports', 'actions']

    def get_reports(self, obj):
        reports = UserRecitationReport.objects.filter(recitation=obj)
        return ReportedRecitationsSerializer(obj, context=self.context).data

    def get_actions(self, obj):
        request = self.context['request']
        actions = []

        reports = UserRecitationReport.objects.filter(recitation=obj)
        for report in reports:
            if report.is_opened:
                actions.append({
                    'text_action_block_reportee': _("Block Reportee"),
                    'url_action_block_reportee': reverse('api-v2:recitations:admin-report:actions',
                                                         args=[report.id, 'block_and_close'])
                })
                actions.append({
                    'text_action_close_report': _("Close Report"),
                    'url_action_close_report': reverse('api-v2:recitations:admin-report:actions',
                                                       args=[report.id, 'close'])
                })

        return actions


class ReportReasonSerializer(serializers.ModelSerializer):
    class Meta:
        model = ReportReason
        fields = ['id', 'reason']
