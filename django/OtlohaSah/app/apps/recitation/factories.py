import random

import factory
from django.core.files import File as DjangoFile
from factory import post_generation, lazy_attribute
from factory.django import DjangoModelFactory

from app.config.main import BASE_DIR
from apps.recitation.models import Recitation
from apps.records.models import Record
from quran_api_client.models import Narration, Chapter, Verse

VERSES = [
    {
        "text": "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ",
        "record": "static/seed/records/001001.mp3",
        "wave": ""
    },
    {
        "text": "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ",
        "record": "static/seed/records/001002.mp3",
        "wave": ""
    },
    {
        "text": "ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ",
        "record": "static/seed/records/001003.mp3",
        "wave": ""
    },
    {
        "text": "مَٰلِكِ يَوۡمِ ٱلدِّينِ",
        "record": "static/seed/records/001004.mp3",
        "wave": ""
    },
    {
        "text": "إِيَّاكَ نَعۡبُدُ وَإِيَّاكَ نَسۡتَعِينُ",
        "record": "static/seed/records/001005.mp3",
        "wave": ""
    },
    {
        "text": "ٱهۡدِنَا ٱلصِّرَٰطَ ٱلۡمُسۡتَقِيمَ",
        "record": "static/seed/records/001006.mp3",
        "wave": ""
    },
    {
        "text": "صِرَٰطَ ٱلَّذِينَ أَنۡعَمۡتَ عَلَيۡهِمۡ غَيۡرِ ٱلۡمَغۡضُوبِ",
        "record": "static/seed/records/001007.mp3",
        "wave": ""
    },
    {
        "text": "الٓمٓ",
        "record": "static/seed/records/002001.mp3",
        "wave": ""
    },
    {
        "text": "ذَٰلِكَ ٱلۡكِتَٰبُ لَا رَيۡبَۛ فِيهِۛ",
        "record": "static/seed/records/002002.mp3",
        "wave": ""
    },
    {
        "text": "ٱلَّذِينَ يُؤۡمِنُونَ بِٱلۡغَيۡبِ وَيُقِيمُونَ ٱلصَّلَوٰةَ",
        "record": "static/seed/records/002003.mp3",
        "wave": ""
    },
    {
        "text": "وَٱلَّذِينَ يُؤۡمِنُونَ بِمَآ أُنزِلَ إِلَيۡكَ وَمَآ",
        "record": "static/seed/records/002004.mp3",
        "wave": ""
    },
    {
        "text": "أُوْلَٰٓئِكَ عَلَىٰ هُدٗى مِّن رَّبِّهِمۡۖ وَأُوْلَٰٓئِكَ هُمُ",
        "record": "static/seed/records/002005.mp3",
        "wave": ""
    },
    {
        "text": "إِنَّ ٱلَّذِينَ كَفَرُواْ سَوَآءٌ عَلَيۡهِمۡ ءَأَنذَرۡتَهُمۡ",
        "record": "static/seed/records/002006.mp3",
        "wave": ""
    },
    {
        "text": "خَتَمَ ٱللَّهُ عَلَىٰ قُلُوبِهِمۡ وَعَلَىٰ سَمۡعِهِمۡۖ",
        "record": "static/seed/records/002007.mp3",
        "wave": ""
    },
]


def get_file(path):
    filename = path.split('/')[-1]
    return DjangoFile(open(BASE_DIR / path, 'rb'), name=filename)


class RecordFactory(DjangoModelFactory):
    class Meta:
        model = Record

    record = factory.sequence(lambda n: get_file(path=VERSES[n % 14].get('record')))


class RecitationFactory(DjangoModelFactory):
    class Meta:
        model = Recitation

    teacher_rate = random.randint(0, 5)
    gender = random.choice(['male', 'female'])
    is_teacher_recitation = False

    @lazy_attribute
    def show_in_general(self):
        return bool(random.randint(0, 1))

    @lazy_attribute
    def result(self):
        return random.choice(['accepted', 'rejected', 'reported'])

    @lazy_attribute
    def show_in_remarkable(self):
        return bool(random.randint(0, 1)) if self.is_remarkable else False

    @lazy_attribute
    def is_remarkable(self):
        return bool(random.randint(0, 1)) if self.result == Recitation.RESULT_ACCEPTED else False

    @lazy_attribute
    def narration_id(self):
        narrations = Narration.objects.all()
        return narrations[random.randint(0, narrations.count() - 1)].id

    @lazy_attribute
    def chapter_id(self):
        chapters = Chapter.objects.filter(chapter_number__lte=20)
        return chapters[random.randint(0, chapters.count() - 1)].id

    @lazy_attribute
    def verse_ids(self):
        verses = Verse.objects.filter(chapter_id=self.chapter_id, narration=self.narration_id)
        start = random.randint(1, verses.count())
        end = random.randint(start, start + 5) if start + 5 < verses.count() else verses.count()
        return str([verse.id for verse in verses[start:end]])

    @lazy_attribute
    def name(self):
        ids = self.verse_ids.replace('[', '').replace(']', '').split(',')
        if len(ids) > 0 and ids[0]:
            verse = Verse.objects.get(id=ids[0])
            text_list = verse.text.split(' ')
            return ' '.join(text_list[:4 if len(text_list) > 4 else len(text_list) - 1])

    @post_generation
    def post(obj, create, extracted, **kwargs):
        RecordFactory(
            content_object=obj,
            record=factory.sequence(lambda n: get_file(path=VERSES[n % 14].get('record'))),
        )
