from django import template

register = template.Library()


@register.inclusion_tag('social/social.html')
def get_social_scripts():
    context = []

    return {
        "providers": context
    }
