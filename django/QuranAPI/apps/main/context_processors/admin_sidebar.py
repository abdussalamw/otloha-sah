from django.urls import reverse
from django.utils.translation import gettext as _


def admin_sidebar(request):
    """ admin tabs """
    user = request.user
    sidebar = [
        {
            "title": _("Quran Control"),
            "type": "header",
            "permissions": True,
            "has_children": False,
        },
        {
            "title": _("Narrations"),
            "type": "list-item",
            "has_children": False,
            "icon": "fa fa-book",
            "url": reverse('admin:narrations:listing'),
            "url_prefix": 'narrations',
            "permissions": user.has_perms(('quran.view_narration',))
        },
        {
            "title": _("Chapters"),
            "type": "list-item",
            "has_children": False,
            "icon": "fa fa-book",
            "url": reverse('admin:chapters:listing'),
            "url_prefix": 'chapters',
            "permissions": True
        },
        {
            "title": _("Parts"),
            "type": "list-item",
            "has_children": False,
            "icon": "fa fa-book",
            "url": reverse('admin:parts:listing'),
            "url_prefix": 'parts',
            "permissions": True
        },
        {
            "title": _("Books"),
            "type": "list-item",
            "has_children": False,
            "icon": "fa fa-book",
            "url": reverse('admin:books:listing'),
            "url_prefix": 'books',
            "permissions": True
        },
        {
            "title": _("Recitations"),
            "type": "list-item",
            "has_children": False,
            "icon": "fa fa-play",
            "url": reverse('admin:recitations:listing'),
            "url_prefix": 'recitations',
            "permissions": True
        },
        {
            "title": _("Explanations"),
            "type": "list-item",
            "has_children": False,
            "icon": "fa fa-sun",
            "url": reverse('admin:explanations:listing'),
            "url_prefix": 'explanations',
            "permissions": True
        },
        {
            "title": _("Tajweed"),
            "type": "list-item",
            "has_children": True,
            "icon": "fa fa-sun",
            "url_prefix": 'tajweed',
            "permissions": True,
            "children": [
                {
                    "title": _("Tajweed Books"),
                    "url": reverse('admin:tajweed:books:listing'),
                    "is_active": 'tajweed/books' in request.path,
                    "permissions": True
                },
                {
                    "title": _("Rules"),
                    "url": reverse('admin:tajweed:rules:listing'),
                    "is_active": 'tajweed/rules' in request.path,
                    "permissions": True
                },

            ]
        },
        {
            "title": _("Translations"),
            "type": "list-item",
            "has_children": False,
            "icon": "fa fa-book",
            "url": reverse('admin:translations:listing'),
            "url_prefix": 'translations',
            "permissions": True
        },
        # {
        #     "title": _("Accounts"),
        #     "type": "header",
        #     "permissions": True,
        #     "has_children": False,
        # },
        # {
        #     "title": _("Manage Accounts"),
        #     "has_children": True,
        #     "icon": "fa fa-users",
        #     "permissions": True,
        #     "children": [
        #         {
        #             "title": _("Staff"),
        #             "url": "#",
        #             "is_active": True,
        #             "permissions": True
        #         },
        #         {
        #             "title": _("Accounts"),
        #             "url": "#",
        #             "is_active": '/staff/' in request.path,
        #             "permissions": True
        #         },
        #         {
        #             "title": _("Groups"),
        #             "url": "#",
        #             "is_active": '/staff/' in request.path,
        #             "permissions": True
        #         },
        #
        #     ]
        # },
        {
            "title": _("Accounts"),
            "type": "header",
            "permissions": True,
            "has_children": False,
        },
        {
            "title": _("Manage Accounts"),
            "has_children": True,
            "icon": "fa fa-users",
            "permissions": True,
            "children": [
                {
                    "title": _("Staff"),
                    "url": reverse('admin:users:stuff-listing'),
                    "is_active": '/staff/' in request.path,
                    "permissions": True
                },
                {
                    "title": _("Groups"),
                    "url": reverse('admin:groups:listing'),
                    "is_active": '/groups/' in request.path,
                    "permissions": True
                },

            ]
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
    return {"admin_sidebar": allowed_sidebar}
