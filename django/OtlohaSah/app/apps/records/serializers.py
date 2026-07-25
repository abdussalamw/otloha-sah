import os
from datetime import timedelta

from django.contrib.contenttypes.models import ContentType
from django.core.files.uploadedfile import UploadedFile
from django.utils.translation import gettext as _
from mutagen import File as MutagenFile
from mutagen.wave import WAVE
from rest_framework import serializers

from apps.records.models import Record


class RecordField(serializers.RelatedField):
    def to_representation(self, value):
        return NewRecordSerializer(instance=value).data

    def to_internal_value(self, data):
        if not data:
            raise serializers.ValidationError(_("Record is required"))
        if Record.objects.filter(pk=data).exists():
            return Record.objects.get(id=data)
        raise serializers.ValidationError(_("Record does not exist"))


class BaseRecordSerializer(serializers.ModelSerializer):
    content_type = serializers.PrimaryKeyRelatedField(queryset=ContentType.objects.all(), write_only=True,
                                                      required=False)
    object_id = serializers.IntegerField(write_only=True, required=False)
    record = serializers.FileField(required=True)

    class Meta:
        model = Record
        fields = (
            'id', 'uuid', 'record', 'wave', 'duration', 'content_type', 'object_id', 'created_at',
            'updated_at')
        read_only_fields = ('id', 'uuid', 'wave', 'duration', 'created_at', 'updated_at')

    def validate_record(self, value):
        # Ensure the uploaded file is a valid audio file
        if not isinstance(value, UploadedFile):
            raise serializers.ValidationError(_("The uploaded file is not valid."))

        try:
            audio_info = MutagenFile(value).info
            # Set audio duration in seconds
            self.duration = timedelta(seconds=audio_info.length)
        except Exception as e:
            raise serializers.ValidationError(_("The uploaded file is not valid."))
        return value

    def create(self, validated_data):
        validated_data['duration'] = self.duration
        return super().create(validated_data)

    def update(self, instance, validated_data):
        instance.record = validated_data['record']
        instance.duration = self.duration
        instance.save()
        return instance


class NewRecordSerializer(serializers.ModelSerializer):
    content_type = serializers.PrimaryKeyRelatedField(queryset=ContentType.objects.all(), write_only=True,
                                                      required=False)
    object_id = serializers.IntegerField(write_only=True, required=False)
    record = serializers.CharField(required=True, write_only=True)
    filename = serializers.SerializerMethodField()

    class Meta:
        model = Record
        fields = (
            'id', 'uuid', 'record', 'wave', 'duration', 'content_type', 'object_id', 'private', 'filename')
        read_only_fields = ('wave', 'duration', 'filename')

    def get_filename(self, obj):
        return obj.record.url.split('/')[-1]

    def validate(self, attrs):
        try:
            path = os.path.join('uploads' if attrs['private'] else 'media', attrs['record'])
            audio_info = WAVE(path).info
            # Set audio duration in seconds
            self.duration = timedelta(seconds=audio_info.length)
        except Exception as e:
            print(e)
            raise serializers.ValidationError(_("The uploaded file is not valid."))
        return attrs

    def create(self, validated_data):
        validated_data['duration'] = self.duration

        return super().create(validated_data)

    def update(self, instance, validated_data):
        instance.record = validated_data['record']
        instance.duration = self.duration
        instance.save()
        return instance
