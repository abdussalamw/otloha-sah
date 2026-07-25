from django import template

from quran_api_client import quran

register = template.Library()


@register.simple_tag
def narrations():
    return quran.narrations()


@register.simple_tag
def narration(narration_id):
    return quran.narration(narration_id)


@register.simple_tag
def chapters():
    return quran.chapters()


@register.simple_tag
def chapter(chapter_id):

    return quran.chapter(chapter_id)


@register.simple_tag
def verses(narration_id, start, end):
    return quran.verses(narration_id, start, end)


@register.simple_tag
def verse(narration_id, verse_id):
    return quran.verse(narration_id, verse_id)


@register.simple_tag
def get_narration_font_class(narration_id):
    return "HafsFont"
