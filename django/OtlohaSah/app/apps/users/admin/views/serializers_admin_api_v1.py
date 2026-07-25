from rest_framework import serializers

from apps.users import config
from apps.users.models import User, USER_MODELS
from django.utils.translation import gettext as _

class UserAdminSerializer(serializers.ModelSerializer):
    urls = serializers.SerializerMethodField()
    fullname = serializers.CharField(source="get_full_name", read_only=True)
    level_text = serializers.CharField(source="get_level_display", read_only=True)
    is_active = serializers.SerializerMethodField()
    actions = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = (
            'id', 'fullname', 'username', 'first_name', 'last_name', 'email', 'phone', 'urls', 'rate', 'level',
            'level_text', 'is_active', 'gender',
            'actions'
        )

    def get_is_active(self, obj):
        return not obj.is_blocked

    def get_urls(self, obj):
        return {
            "profile": "#"
        }

    def get_actions(self, obj):
        user = self.context["request"].user
        user_type = obj.get_user_type
        model = USER_MODELS.get(user_type)
        user_type_perm_name = model._meta.model_name
        return [
            {
                "permission": user.has_perm(f"users.toggle_block_{user_type_perm_name}"),
                "text": _("Unblock") if obj.is_blocked else _("Block"),
                "attrs": {
                    "href": obj.get_toggle_block_url,
                    "class": "menu-link px-3" + (" text-danger" if not obj.is_blocked else " text-success"),
                    "data-toggle": "confirm",
                    "data-request-method": "POST",
                    "data-confirm-message": _("Are you sure you want to block this {user_type}?").format(
                        user_type=config.get_user_type_verbose_name_by_key(user_type)
                    ),
                }
            }
        ]