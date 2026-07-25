from base_template.context_processors import get_menu_from_apps
from django.templatetags.static import static
from django.utils.translation import get_language


def get_sidebar(request):
    return get_menu_from_apps(request, 'admin')


def get_assets(request):
    css = [
        {
            "rel": "short icon",
            "href": static("images/favicon.ico")
        },
        {
            "rel": "stylesheet",
            "href": "https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700"
        },
        {
            "rel": "stylesheet",
            "href": static('fonts/quran-fonts.css')
        }
    ]
    js = [
        {"src": static("base_template/plugins/global/plugins.bundle.js")},
        {"src": static("base_template/js/scripts.bundle.js")},
        {"src": static("base_template/js/utils.js")},
        # {"src": static("fritill_forms/form-modal.js")},
        {"src": static("custom/formValidation.js")},
        {"src": static("custom/modalHelpers.js")},
        {"src": static("custom/toastr.js")},
        {"src": static("custom/utils.js")},
        {"src": static("records/audio-player.js")},
    ]

    head_js = [
        {
            "type": "module",
            "src": static("components/dist/components/components.esm.js")
        },
        {
            "type": "module",
            "src": static("components/dist/components/components.js")
        },
    ]
    from base_template.utils import get_settings_value
    if get_settings_value("BASE_TEMPLATE_MULTIPLE_LANGUAGES", False):
        from django.urls import reverse
        js.insert(0, {
            "src": reverse("javascript-catalog")
        })
    from django.conf import settings
    if get_language() in settings.LANGUAGES_BIDI:
        css.append({
            "rel": "stylesheet",
            "href": static("base_template/plugins/global/plugins.bundle.rtl.css"),
            "type": "text/css"
        })
        css.append({
            "rel": "stylesheet",
            "href": static("base_template/css/style.bundle.rtl.css"),
            "type": "text/css"
        })
    else:
        css.append({
            "rel": "stylesheet",
            "href": static("base_template/plugins/global/plugins.bundle.css"),
            "type": "text/css"
        })
        css.append({
            "rel": "stylesheet",
            "href": static("base_template/css/style.bundle.css"),
            "type": "text/css"
        })
    return {"css": css, "js": js, "head_js": head_js}
