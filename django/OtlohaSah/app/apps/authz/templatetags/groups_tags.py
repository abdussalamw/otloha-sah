from django import template
from django.apps import apps
from django.contrib.auth.models import Permission
from django.db.models import Q

register = template.Library()


@register.inclusion_tag('groups/form/_permissions.html')
def permissions_field(perms_field):
    permissions = {}
    value = perms_field.value()
    queryset = Permission.objects.prefetch_related('content_type').exclude(Q(
        Q(content_type__app_label__in=[
            "authtoken", "contenttypes", "django_celery_beat", "django_celery_results",
            "sessions", "token_blacklist", "sites", 'cities_light', 'django_rest_passwordreset', 'model_status'
        ]) | Q(content_type__model__in=['permission'])
    ))

    for item in queryset:
        app_label = item.content_type.app_label
        if app_label == 'users':
            app_label = 'auth'
        if permissions.get(app_label, None) is None:
            app_config = apps.get_app_config(app_label)
            permissions[app_label] = {
                "name": app_config.verbose_name,
                "models": {},
            }
        if permissions[app_label]["models"].get(item.content_type.model, None) is None:
            permissions[app_label]["models"][item.content_type.model] = {
                "permissions": [],
                "name": item.content_type.model_class()._meta.verbose_name_plural,
            }

        permissions[app_label]["models"][item.content_type.model]["permissions"].append(item)

    return {
        'permissions': permissions,
        "field": perms_field,
    }


@register.simple_tag
def get_permissions_list(item, limited=False):
    permissions = item.permissions.all()
    if limited:
        permissions = permissions[:5]

    count = item.permissions.count() - 5 if limited else 0

    return {
        "items": permissions,
        "count": count if count > 0 else None,
    }
