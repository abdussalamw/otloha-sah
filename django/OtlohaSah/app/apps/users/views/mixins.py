from django.http import Http404

from apps.users import config
from apps.users.models import USER_MODELS


class UserTypeValidationMixin:
    def dispatch(self, request, *args, **kwargs):
        user_type = kwargs.get('user_type')
        user_types = dict(config.USER_TYPES_KEYS_PLURAL)
        if user_type not in user_types.keys():
            raise Http404("Invalid parameter.")

        self.user_type = user_types.get(user_type)
        self.model = USER_MODELS.get(self.user_type)
        self.permission_model_name = self.get_permission_model_name()
        return super().dispatch(request, *args, **kwargs)

    def get_permission_model_name(self):
        return self.user_type.replace("_", "")
