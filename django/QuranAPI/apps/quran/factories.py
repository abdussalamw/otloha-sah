import factory

from apps.quran.models import *


class PageFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Page

    page_number = factory.Faker('random_number')
    image = '/media/page_pictures/example.jpg'
    sub_part = factory.Iterator(range(1, 61))


VERSE_PLACE = ["maka", "el-madina"]

chapters = [
    {'name': "الفاتحة", 'origin': "maka"},
    {'name': "البقرة", 'origin': "el-madina"},
    {'name': "آل عمران", 'origin': "el-madina"},
    {'name': "النساء", 'origin': "el-madina"},
    {'name': "المائدة", 'origin': "el-madina"},
    {'name': "الأنعام", 'origin': "maka"},
    {'name': "الأعراف", 'origin': "maka"},
    {'name': "الأنفال", 'origin': "el-madina"},
    {'name': "التوبة", 'origin': "el-madina"},
    {'name': "يونس", 'origin': "maka"},
    {'name': "هود", 'origin': "maka"},
    {'name': "يوسف", 'origin': "maka"},
    {'name': "الرعد", 'origin': "el-madina"},
    {'name': "ابراهيم", 'origin': "maka"},
    {'name': "الحجر", 'origin': "maka"},
    {'name': "النحل", 'origin': "maka"},
    {'name': "الإسراء", 'origin': "maka"},
    {'name': "الكهف", 'origin': "maka"},
    {'name': "مريم", 'origin': "maka"},
    {'name': "طه", 'origin': "maka"},
    {'name': "الأنبياء", 'origin': "maka"},
    {'name': "الحج", 'origin': "el-madina"},
    {'name': "المؤمنون", 'origin': "maka"},
    {'name': "النور", 'origin': "el-madina"},
    {'name': "الفرقان", 'origin': "maka"},
    {'name': "الشعراء", 'origin': "maka"},
    {'name': "النمل", 'origin': "maka"},
    {'name': "القصص", 'origin': "maka"},
    {'name': "العنكبوت", 'origin': "maka"},
    {'name': "الروم", 'origin': "maka"},
    {'name': "لقمان", 'origin': "maka"},
    {'name': "السجدة", 'origin': "maka"},
    {'name': "الأحزاب", 'origin': "el-madina"},
    {'name': "سبإ", 'origin': "maka"},
    {'name': "فاطر", 'origin': "maka"},
    {'name': "يس", 'origin': "maka"},
    {'name': "الصافات", 'origin': "maka"},
    {'name': "ص", 'origin': "maka"},
    {'name': "الزمر", 'origin': "maka"},
    {'name': "غافر", 'origin': "maka"},
    {'name': "فصلت", 'origin': "maka"},
    {'name': "الشورى", 'origin': "maka"},
    {'name': "الزخرف", 'origin': "maka"},
    {'name': "الدخان", 'origin': "maka"},
    {'name': "الجاثية", 'origin': "maka"},
    {'name': "الأحقاف", 'origin': "maka"},
    {'name': "محمد", 'origin': "el-madina"},
    {'name': "الفتح", 'origin': "el-madina"},
    {'name': "الحجرات", 'origin': "el-madina"},
    {'name': "ق", 'origin': "maka"},
    {'name': "الذاريات", 'origin': "maka"},
    {'name': "الطور", 'origin': "maka"},
    {'name': "النجم", 'origin': "maka"},
    {'name': "القمر", 'origin': "maka"},
    {'name': "الرحمن", 'origin': "el-madina"},
    {'name': "الواقعة", 'origin': "maka"},
    {'name': "الحديد", 'origin': "el-madina"},
    {'name': "المجادلة", 'origin': "el-madina"},
    {'name': "الحشر", 'origin': "el-madina"},
    {'name': "الممتحنة", 'origin': "el-madina"},
    {'name': "الصف", 'origin': "el-madina"},
    {'name': "الجمعة", 'origin': "el-madina"},
    {'name': "المنافقون", 'origin': "el-madina"},
    {'name': "التغابن", 'origin': "el-madina"},
    {'name': "الطلاق", 'origin': "el-madina"},
    {'name': "التحريم", 'origin': "el-madina"},
    {'name': "الملك", 'origin': "maka"},
    {'name': "القلم", 'origin': "maka"},
    {'name': "الحاقة", 'origin': "maka"},
    {'name': "المعارج", 'origin': "maka"},
    {'name': "نوح", 'origin': "maka"},
    {'name': "الجن", 'origin': "maka"},
    {'name': "المزمل", 'origin': "maka"},
    {'name': "المدثر", 'origin': "maka"},
    {'name': "القيامة", 'origin': "maka"},
    {'name': "الإنسان", 'origin': "el-madina"},
    {'name': "المرسلات", 'origin': "maka"},
    {'name': "النبأ", 'origin': "maka"},
    {'name': "النازعات", 'origin': "maka"},
    {'name': "عبس", 'origin': "maka"},
    {'name': "التكوير", 'origin': "maka"},
    {'name': "الإنفطار", 'origin': "maka"},
    {'name': "المطففين", 'origin': "maka"},
    {'name': "الإنشقاق", 'origin': "maka"},
    {'name': "البروج", 'origin': "maka"},
    {'name': "الطارق", 'origin': "maka"},
    {'name': "الأعلى", 'origin': "maka"},
    {'name': "الغاشية", 'origin': "maka"},
    {'name': "الفجر", 'origin': "maka"},
    {'name': "البلد", 'origin': "maka"},
    {'name': "الشمس", 'origin': "maka"},
    {'name': "الليل", 'origin': "maka"},
    {'name': "الضحى", 'origin': "maka"},
    {'name': "الشرح", 'origin': "maka"},
    {'name': "التين", 'origin': "maka"},
    {'name': "العلق", 'origin': "maka"},
    {'name': "القدر", 'origin': "maka"},
    {'name': "البيِّنة", 'origin': "el-madina"},
    {'name': "الزلزلة", 'origin': "el-madina"},
    {'name': "العاديات", 'origin': "maka"},
    {'name': "القارعة", 'origin': "maka"},
    {'name': "التكاثر", 'origin': "maka"},
    {'name': "العصر", 'origin': "maka"},
    {'name': "الهمزة", 'origin': "maka"},
    {'name': "الفيل", 'origin': "maka"},
    {'name': "قريش", 'origin': "maka"},
    {'name': "الماعون", 'origin': "maka"},
    {'name': "الكوثر", 'origin': "maka"},
    {'name': "الكافرون", 'origin': "maka"},
    {'name': "النصر", 'origin': "el-madina"},
    {'name': "المسد", 'origin': "maka"},
    {'name': "الإخلاص", 'origin': "maka"},
    {'name': "الفلق", 'origin': "maka"},
    {'name': "الناس", 'origin': "maka"},

]


class BookFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Book

    name = factory.Dict({"ar": factory.Faker("job")})


class GlyphFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Glyph

    min_x = factory.Faker('random_number')
    min_y = factory.Faker('random_number')
    max_x = factory.Faker('random_number')
    max_y = factory.Faker('random_number')
    line_number = factory.Faker('random_number')
    position = factory.Faker('random_number')
