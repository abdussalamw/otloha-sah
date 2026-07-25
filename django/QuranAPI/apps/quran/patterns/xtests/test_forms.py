import shutil

from django.core.files import File
from django.core.files.uploadedfile import SimpleUploadedFile
from django.forms import ModelForm
from django.test import TestCase
from django.test import override_settings

from apps.quran.forms import BookImagesUploadForm, BookImagesPatternUploadForm
from apps.quran.factories import NarrationFactory, BookFactory
from apps.quran.models import BookImageUpload, BookPattern

TEST_DIR = 'test_data'


class BookImagesUploadFormTestCase(TestCase):
    def setUp(self):
        self.book = BookFactory(narration=NarrationFactory())

    def tearDown(self):
        try:
            shutil.rmtree(TEST_DIR)
        except OSError:
            pass

    def test_it_extend_ModelForm(self):
        self.assertTrue(isinstance(BookImagesUploadForm(), ModelForm))

    def test_it_has_meta_class(self):
        self.assertIn('Meta', BookImagesUploadForm.__dict__)

    def test_it_use_BookImageUpload_model(self):
        self.assertEqual(BookImagesUploadForm.Meta.model, BookImageUpload)

    def test_form_fields(self):
        self.assertEqual(BookImagesUploadForm.Meta.fields, ['file'])

    def test_validate_form_for_a_blank_file_field(self):
        form = BookImagesUploadForm(data={'file': '', 'book': self.book.pk})
        self.assertFalse(form.is_valid())

    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def test_it_render_file_field_in_html(self):
        file = SimpleUploadedFile("file.txt", b"file_content")
        form = BookImagesUploadForm(data={'file': file, 'book': self.book.pk}, files={'file': file})
        self.assertIn('name="file"', form.as_p())

    def test_it_save_the_number_of_pages(self):
        file = File(open('apps/quran/book/tests/files/test_zip.zip', 'rb'))
        form = BookImagesUploadForm(data={'file': file}, files={'file': file})
        f = form.is_valid()
        instance = form.save()
        self.assertEqual(instance.number_of_pages, 3)

    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def test_it_raise_error_if_the_file_is_not_zip_file(self):
        file = SimpleUploadedFile("file.txt", b"file_content")
        form = BookImagesUploadForm(data={'file': file}, files={'file': file})
        self.assertFalse(form.is_valid())


class BookImagePatternFormTestCase(TestCase):
    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def setUp(self):
        self.book = BookFactory(narration=NarrationFactory())
        file = SimpleUploadedFile('test.txt', b'content')
        self.book_images = BookImageUpload.objects.create(file=file, book=self.book, number_of_pages=20)

    def tearDown(self):
        try:
            shutil.rmtree(TEST_DIR)
        except OSError:
            pass

    def test_it_extend_ModelForm(self):
        self.assertTrue(isinstance(BookImagesPatternUploadForm(), ModelForm))

    def test_it_has_meta_class(self):
        self.assertIn('Meta', BookImagesPatternUploadForm.__dict__)

    def test_it_use_BookImagesPatternUploadForm_model(self):
        self.assertEqual(BookPattern, BookImagesPatternUploadForm.Meta.model)

    def test_form_fields(self):
        self.assertEqual(BookImagesPatternUploadForm.Meta.fields, ['file', 'type'])

    def test_validate_form_for_a_blank_file_field(self):
        form = BookImagesPatternUploadForm(data={'file': '', 'type': 'marker'})
        self.assertFalse(form.is_valid())

    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def test_validate_form_for_missing_type_field(self):
        file = SimpleUploadedFile("file.txt", b"file_content")
        form = BookImagesPatternUploadForm(data={'file': file, 'type': ''})

        self.assertFalse(form.is_valid())
        self.assertEqual(form.errors['type'], ['هذا الحقل مطلوب.'])

    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def test_it_render_file_field_in_html(self):
        file = SimpleUploadedFile("file.txt", b"file_content")
        form = BookImagesPatternUploadForm(
            data={'file': file, 'type': 'marker'})
        self.assertIn('name="file"', form.as_p())

    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def test_it_render_type_field_in_html(self):
        file = SimpleUploadedFile("file.txt", b"file_content")
        form = BookImagesPatternUploadForm(
            data={'file': file, 'type': 'marker'})
        self.assertIn('name="type"', form.as_p())
