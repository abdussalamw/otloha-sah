from django.urls import reverse
from django.utils.translation import gettext as _


def user_sidebar(request):
    """ admin tabs """
    user = request.user
    sidebar = []
    if user.is_authenticated:
        sidebar = [
            {
                "title": _("User Profile Control"),
                "type": "header",
                "permissions": True,
                "has_children": False,
            },
            {
                "title": _("Profile"),
                "type": "list-item",
                "has_children": False,
                "url": reverse('site:profile:profile-update', args=[user.id]),
                "url_prefix": 'profile',
                "permissions": True
            },
            {
                "title": _("Update Profile"),
                "type": "list-item",
                "has_children": False,
                "url": reverse('site:profile:profile-update', args=[user.id]),
                "url_prefix": 'profile',
                "permissions": True
            },
            {
                "title": _("Manage Your Profile"),
                "has_children": True,
                "permissions": True,
                "children": [
                    {
                        "title": _("Change Password"),
                        "icon": "fas fa-edit",
                        "url": reverse('site:profile:password-change'),
                        "is_active": '/password-change/' in request.path,
                        "permissions": True
                    },
                    {
                        "title": _("Update Email"),
                        "icon": "fas fa-edit",
                        "url": reverse('site:profile:email-update'),
                        "is_active": '/email-change/' in request.path,
                        "permissions": True
                    },
                    {
                        "title": _("Update Phone Number"),
                        "icon": "fas fa-edit",
                        "url": reverse('site:profile:phone-update'),
                        "is_active": '/phone-change/' in request.path,
                        "permissions": True
                    },

                ]
            },
            {
                "title": _("Manage Your Apps"),
                "type": "header",
                "permissions": True,
                "has_children": False,
            },
            {
                "title": _("All Apps"),
                "has_children": False,
                "url": reverse('oauth2_provider:list'),
                "icon": "fas fa-list",
                "is_active": 'o/applications/' in request.path,
                "permissions": True
            },
            {
                "title": _("Register New App"),
                "has_children": False,
                "url": reverse('oauth2_provider:register'),
                "is_active": 'o/applications/register/' in request.path,
                "permissions": True
            },
        ]

    allowed_sidebar = []
    for item in sidebar:
        if item['permissions']:
            if item['has_children']:
                allowed_items = []
                for sub_item in item['children']:
                    allowed_items.append(sub_item)
                item['children'] = allowed_items
        allowed_sidebar.append(item)
    return {"user_sidebar": allowed_sidebar}
