import zipfile

from apps.chapters.models import Chapter
from apps.files_handler.models import File
from apps.recitations.models import RecitationVerse


def process_files(file_id):
    file_object = File.objects.get(pk=file_id)
    recitation = file_object.content_object
    path = file_object.file.path
    files = []

    for zipfile_name in zipfile.ZipFile(path).filelist:
        # if zipfile_name.filename.split('.')[1] in ['mp3', 'wav']:
        files.append(zipfile_name.filename)

    uncompressed_files_dir = 'recitations/{}/recitation_verses'.format(recitation.id)
    with zipfile.ZipFile(path, "r") as zip_ref:
        zip_ref.extractall('media/' + uncompressed_files_dir)
    chapters = Chapter.objects.all()
    recitation_verses = recitation.recitationverse_set.all()
    to_create = []
    to_update = []

    for file in files:
        file_path = '{}/{}'.format(uncompressed_files_dir, file)
        reference = file.split('.')[0]

        if '.mp3' not in file or not reference.isnumeric():
            continue

        chapter = chapters.get(id=int(reference[:3]))
        verse_number = int(reference[3:])
        verse = None
        if recitation_verses.filter(recitation=recitation, chapter=chapter, verse_number=verse_number).exists():
            verse = recitation_verses.get(recitation=recitation, chapter=chapter, verse_number=verse_number)
            verse.record = file_path
            to_update.append(verse)

        if not verse:
            to_create.append(RecitationVerse(
                chapter=chapter,
                verse_number=verse_number,
                record=file_path,
                recitation=recitation
            ))
    RecitationVerse.objects.bulk_create(to_create)
    RecitationVerse.objects.bulk_update(to_update, ['record'])

"""
from apps.recitations.tasks import process_files
process_files(10)

"""
