from django import template
from django.urls import reverse
from django.utils.translation import gettext as _

from apps.users import config
from apps.users.models import USER_MODELS

register = template.Library()


@register.inclusion_tag('users/admin/details/tabs.html')
def get_user_tabs(user_type, details_type, user):
    tabs = []
    if user_type == 'students':
        tabs.append({
            "title": _("Progress"),
            "url": reverse("admin:users:details", args=[user_type, user.pk]),
            "is_active": details_type == 'progress'
        })
        tabs.append({
            "title": _("Recitations"),
            "url": reverse("admin:users:details-inner", args=[user_type, user.pk, 'recitations']),
            "is_active": details_type == 'recitations'
        })
    elif user_type == 'teachers':
        tabs.append({
            "title": _("Students"),
            "url": reverse("admin:users:details-inner", args=[user_type, user.pk, 'students']),
            "is_active": details_type == 'students'
        })
        if user.teacherprofile.teacher_type == 'paid':
            tabs.append({
                "title": _("Accounting"),
                "url": reverse("admin:users:details-inner", args=[user_type, user.pk, 'accounting']),
                "is_active": details_type == 'accounting'
            })
        tabs.append({
            "title": _("Narrations"),
            "url": reverse("admin:users:details-inner", args=[user_type, user.pk, 'narrations']),
            "is_active": details_type == 'narrations'
        })
        tabs.append({
            "title": _("Corrected Recitations"),
            "url": reverse("admin:users:details-inner", args=[user_type, user.pk, 'corrected-recitations']),
            "is_active": details_type == 'corrected-recitations'
        })
        tabs.append({
            "title": _("Recitations"),
            "url": reverse("admin:users:details-inner", args=[user_type, user.pk, 'recitations']),
            "is_active": details_type == 'recitations'
        })
        tabs.append({
            "title": _("Teacher Recitations"),
            "url": reverse("admin:users:details-inner", args=[user_type, user.pk, 'teacher-recitations']),
            "is_active": details_type == 'teacher-recitations'
        })
    return {"tabs": tabs}


def check_permission(item):
    return item.get('permission')


@register.simple_tag
def get_user_item_actions(user, obj):
    actions = []
    user_type = obj.get_user_type
    model = USER_MODELS.get(user_type)
    user_type_perm_name = model._meta.model_name

    available_actions = {
        "admin": {
            "edit": {
                "permission": user.has_perm("users.change_admin") and user != obj,
                "text": _("Edit"),
                "attrs": {
                    "href": reverse("admin:users:edit", args=[
                        "admins", obj.pk]),
                    "class": "menu-link px-3",
                }
            },
        },
        "teacher": {
            "edit": {
                "permission": user.has_perm("users.change_teacher"),
                "text": _("Edit"),
                "attrs": {
                    "href": reverse("admin:users:edit", args=[
                        "teachers", obj.pk]),
                    "class": "menu-link px-3",
                }
            },
            "reject": {
                "permission": user.has_perm("users.reject_teacherprofile"),
                "text": _("Reject"),
                "attrs": {
                    "href": reverse("admin:users:toggle-teacher-action", args=[
                        "teachers", obj.pk, 'reject']),
                    "class": "menu-link px-3",
                    "data-toggle": "confirm",
                    "data-request-method": "POST",
                    "data-confirm-message": _(
                        "Are you sure you would like to reject this teacher!"),
                }
            },
            "approve": {
                "permission": user.has_perm("users.approve_teacherprofile"),
                "text": _("Approve"),
                "attrs": {
                    "href": reverse("admin:users:toggle-teacher-action", args=[
                        "teachers", obj.pk, 'approve']),
                    "class": "menu-link px-3",
                    "data-toggle": "confirm",
                    "data-request-method": "POST",
                    "data-confirm-message": _("Are you sure you would like to approve this teacher!")
                }
            },
            # "toggle_suspend": ,
            # "toggle_recitation_engagement":
        },
        "all": {
            "block": {
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
        }
    }

    if user_type == 'admin':
        if check_permission(available_actions[user_type]['edit']):
            actions.append(available_actions[user_type]['edit'])

    if user_type == 'teacher' and hasattr(obj, "teacherprofile"):

        if available_actions['teacher']['edit']['permission']:
            actions.append(available_actions['teacher']['edit'])
        if obj.teacherprofile.status == 'pending':
            if check_permission(available_actions[user_type]['reject']):
                actions.append(available_actions[user_type]['reject'])
            if check_permission(available_actions[user_type]['approve']):
                actions.append(available_actions[user_type]['approve'])
        else:
            available_actions[user_type]['toggle_suspend'] = {
                "permission": user.has_perm(
                    f"users.suspend_teacherprofile" if obj.teacherprofile.is_active else f"users.unsuspend_teacherprofile"),
                "text": _("Suspend") if obj.teacherprofile.is_active else _("Unsuspend"),
                "attrs": {
                    "href": reverse("admin:users:toggle-teacher-action", args=[
                        "teachers", obj.pk, 'suspend' if obj.teacherprofile.is_active else 'unsuspend']),
                    "class": "menu-link px-3" + (" text-danger" if obj.teacherprofile.is_active else ""),
                    "data-toggle": "confirm",
                    "data-request-method": "POST",
                    "data-confirm-message": _(
                        "Are you sure you would like to suspend this teacher!") if obj.teacherprofile.is_active else _(
                        "Are you sure you would like to unsuspend this teacher!"),
                }
            }
            if check_permission(available_actions[user_type]['toggle_suspend']):
                actions.append(available_actions[user_type]['toggle_suspend'])
            available_actions[user_type]['toggle_recitation_engagement'] = {
                "permission": user.has_perm("users.toggle_reply_on_every_verse_in_recitation_teacherprofile"),
                "text": _(
                    "Can Reply on every Verse in Recitation") if not obj.teacherprofile.can_reply_on_every_verse_in_recitation else _(
                    "Can Reply on all Recitation Only"),
                "attrs": {
                    "href": reverse("admin:users:toggle-teacher-action", args=[
                        "teachers", obj.pk,
                        'can_reply_on_every_verse_in_recitation' if not obj.teacherprofile.can_reply_on_every_verse_in_recitation else 'can_reply_on_whole_recitation']),
                    "class": "menu-link px-3",
                    "data-toggle": "confirm",
                    "data-request-method": "POST",
                    "data-confirm-message": _(
                        "Are you sure you would like to change this teacher's recitation engagement level!"),
                }
            }
            if obj.teacherprofile.is_active and check_permission(
                    available_actions[user_type]['toggle_recitation_engagement']):
                actions.append(available_actions[user_type]['toggle_recitation_engagement'])

    for key, action in available_actions['all'].items():
        if user_type == 'admin':
            if key == 'block' and user == obj:
                continue

        if check_permission(action):
            actions.append(action)

    return actions


@register.simple_tag
def get_user_bulk_actions(user, user_type):
    actions = []
    user_type_name = dict(config.USER_TYPES_KEYS_PLURAL).get(user_type)
    model = USER_MODELS.get(user_type_name)
    user_type_perm_name = model._meta.model_name

    if user.has_perm(f"users.toggle_block_{user_type_perm_name}"):
        actions.append({
            "text": _("Block"),
            "attrs": {
                "href": reverse("admin:users:bulk-toggle-block", args=[user_type, 'block']),
                "class": "menu-link text-danger px-3",
                "data-toggle": "bulk-action",
                "data-request-method": "POST",
                "data-confirm-message": _("Are you sure you want to block these {user_type}?").format(
                    user_type=user_type),
                "data-input-type": "selected",
            }
        })
        actions.append({
            "text": _("Unblock"),
            "attrs": {
                "href": reverse("admin:users:bulk-toggle-block", args=[user_type, 'unblock']),
                "class": "menu-link text-success px-3",
                "data-toggle": "bulk-action",
                "data-request-method": "POST",
                "data-confirm-message": _("Are you sure you want to unblock these {user_type}?").format(
                    user_type=user_type),
                "data-input-type": "selected",
            }
        })

    return actions


@register.simple_tag
def get_user_actions(request, user_type):
    actions = []
    user = request.user
    user_type_name = dict(config.USER_TYPES_KEYS_PLURAL).get(user_type)
    user_type_verbose_name_plural = dict(config.USER_TYPES_KEYS_PLURAL_VERBOSE_NAME_PLURAL).get(user_type)
    model = USER_MODELS.get(user_type_name)
    user_type_perm_name = model._meta.model_name
    available_actions = {
        "admins": {
            "add": {
                "permission": user.has_perm("users.add_admin"),
                "text": _("Add New Admin"),
                "attrs": {
                    "href": reverse("admin:users:create", args=[user_type]),
                    "class": "menu-link px-3",
                }
            }
        },
        "teachers": {
            "export_csv": {
                "permission": user.has_perm(f"users.view_{user_type_perm_name}") and request.GET,
                "text": _("Export as csv"),
                "attrs": {
                    "href": reverse("admin:users:export-csv", args=[user_type, 'export']),
                    "class": "menu-link px-3",
                }
            }
        },
        "students": {},
        "all": {
            "block_filtered": {
                "permission": user.has_perm(f"users.toggle_block_{user_type_perm_name}") and request.GET,
                "text": _("Block filtered {user_type}").format(user_type=user_type_verbose_name_plural),
                "attrs": {
                    "href": reverse("admin:users:bulk-toggle-block", args=[user_type, 'block']),
                    "class": "menu-link text-danger px-3",
                    "data-toggle": "bulk-action",
                    "data-request-method": "POST",
                    "data-confirm-message": _("Are you sure you want to block filtered {user_type}?").format(
                        user_type=user_type_verbose_name_plural),
                    "data-input-type": "queryset",
                }
            },
            "block_all": {
                "permission": user.has_perm(f"users.toggle_block_{user_type_perm_name}"),
                "text": _("Block all {user_type}").format(user_type=user_type_verbose_name_plural),
                "attrs": {
                    "href": reverse("admin:users:bulk-toggle-block", args=[user_type, 'block']),
                    "class": "menu-link text-danger px-3",
                    "data-toggle": "bulk-action",
                    "data-request-method": "POST",
                    "data-confirm-message": _("Are you sure you want to block all {user_type}?").format(
                        user_type=user_type_verbose_name_plural),
                    "data-input-type": "none",
                }
            },
            "unblock_filtered": {
                "permission": user.has_perm(f"users.toggle_block_{user_type_perm_name}") and request.GET,
                "text": _("Unblock filtered {user_type}").format(user_type=user_type_verbose_name_plural),
                "attrs": {
                    "href": reverse("admin:users:bulk-toggle-block", args=[user_type, 'unblock']),
                    "class": "menu-link text-success px-3",
                    "data-toggle": "bulk-action",
                    "data-request-method": "POST",
                    "data-confirm-message": _("Are you sure you want to unblock filtered {user_type}?").format(
                        user_type=user_type),
                    "data-input-type": "queryset",
                }
            },
            "unblock_all": {
                "permission": user.has_perm(f"users.toggle_block_{user_type_perm_name}"),
                "text": _("Unblock all {user_type}").format(user_type=user_type_verbose_name_plural),
                "attrs": {
                    "href": reverse("admin:users:bulk-toggle-block", args=[user_type, 'unblock']),
                    "class": "menu-link text-success px-3",
                    "data-toggle": "bulk-action",
                    "data-request-method": "POST",
                    "data-confirm-message": _("Are you sure you want to unblock all {user_type}?").format(
                        user_type=user_type_verbose_name_plural),
                    "data-input-type": "none",
                }
            },
        }
    }
    if user_type == 'admins':
        if available_actions[user_type]['add']['permission']:
            actions.append(available_actions[user_type]['add'])

    if user_type == 'teachers':
        actions.append(available_actions[user_type]['export_csv'])

    for key, action in available_actions['all'].items():
        if action['permission']:
            actions.append(action)

    return actions
