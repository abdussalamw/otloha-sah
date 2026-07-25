from .models import Setting, UserSetting


def cast_value_to_value_type(value, value_type):
    if value_type == 'number':
        value = float(value)
    elif value_type == 'boolean':
        value = bool(value == 'True' or value == '1' or value == 'true')
    return value


def get_setting(key):
    setting = Setting.objects.get(key=key)
    return cast_value_to_value_type(setting.value, setting.value_type)


def get_user_setting(user, key):
    setting = UserSetting.objects.filter(user=user, key=key)
    if setting.exists():
        return cast_value_to_value_type(setting.first().value, setting.first().value_type)
    return False
