from django.utils.translation import gettext as _
from rest_framework import serializers
from rest_framework.reverse import reverse

from apps.ads.models import Ad


class CreateOrUpdateAdSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ad
        fields = ('id', 'title', 'url', 'is_active', 'image')


class ListAdSerializer(serializers.ModelSerializer):
    actions = serializers.SerializerMethodField()

    class Meta:
        model = Ad
        fields = ('id', 'title', 'url', 'image', 'is_active', 'actions')

    def get_actions(self, obj):
        return [
            {
                'text': _("Suspend") if obj.is_active else _("Unsuspend"),
                'url_action': reverse('admin-v1:ads:action', args=[
                    obj.pk, 'suspend' if obj.is_active else 'unsuspend',
                ]),
                'delete': _("Delete"),
                'url_delete': reverse('admin-v1:ads:delete', args=[obj.pk])
            }
        ]
