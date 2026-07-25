from rest_framework import serializers


class StatisticSerializer(serializers.Serializer):
    narration_id = serializers.IntegerField()
    accepted_recitations = serializers.IntegerField()
    rejected_recitations = serializers.IntegerField()
    pending_recitations = serializers.IntegerField()
    number_of_recitations = serializers.IntegerField()
    percentage = serializers.FloatField()


class RecitationProgressSerializer(serializers.Serializer):
    pending = serializers.DictField(child=serializers.ListField(child=serializers.IntegerField()))
    accepted = serializers.DictField(child=serializers.ListField(child=serializers.IntegerField()))
    rejected = serializers.DictField(child=serializers.ListField(child=serializers.IntegerField()))
