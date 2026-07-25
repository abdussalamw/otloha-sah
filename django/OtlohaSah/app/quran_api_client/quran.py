from django.core.cache import cache

from .models import Chapter, Narration, Verse


def narrations():
    return cache.get('narrations')


def narration(narration_id):
    if cache.get('narrations.{}'.format(narration_id)):
        return cache.get('narrations.{}'.format(narration_id))

    narration_obj = Narration.objects.get(id=narration_id)
    cache.set('narrations.{}'.format(narration_id), narration_obj)
    return narration_obj


def chapters():
    return cache.get('chapters')


def chapter(chapter_id):
    if cache.get('chapters.{}'.format(chapter_id)):
        return cache.get('chapters.{}'.format(chapter_id))

    try:
        chapter_obj = Chapter.objects.get(id=chapter_id)
        cache.set('chapters.{}'.format(chapter_id), chapter_obj)
        return chapter_obj
    except Exception as e:
        pass


def verses(narration_id, start, end):
    res = []
    for i in range(start, end):
        res.append(verse(narration_id, i))
    return res


def verse(narration_id, verse_id):
    key = 'narrations.{}.verses.{}'.format(narration_id, verse_id)
    if cache.get(key, None):
        return cache.get(key)

    try:
        verse_id_obj = Verse.objects.get(narration_id=narration_id, id=verse_id)
        cache.set(key, verse_id_obj)
        return verse_id_obj
    except Exception as e:
        pass
