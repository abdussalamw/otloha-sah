from django.test import TestCase

from app.form_checkers import check_required
from apps.quran.page.admin_form import UpdateVerseForm, UpdatePageForm
from apps.quran.factories import VerseFactory, PageFactory


class UpdateVerseFormValidationTest(TestCase):
    def setUp(self):
        self.verse = VerseFactory()
        self.Form = UpdateVerseForm

        self.DEFAULT_DATA = {
            "text": "page test",
            "uthmanic_text": "test verses serializer",
            "image": "/media/verse_pictures/example.jpg",
            'verse_number': 2,
            'page_number': 3,
        }

    def test_verse_number_is_required(self):
        check_required(self, 'verse_number')

    def test_verse_form_is_valid(self):
        form = UpdateVerseForm(data=self.DEFAULT_DATA)
        self.assertTrue(form.is_valid())

    def test_verse_from_throw_error_if_provides_incomplete_data(self):
        form = UpdateVerseForm(data={})
        self.assertFalse(form.is_valid())

    def test_verse_from_throw_error_if_email_is_email_is_already_exists(self):
        self.DEFAULT_DATA.pop('verse_number')
        form = UpdateVerseForm(data=self.DEFAULT_DATA)
        self.assertFalse(form.is_valid())

    def test_update_verse_form_with_valid_data(self):
        form = UpdateVerseForm(instance=self.verse, data=self.DEFAULT_DATA)
        self.assertTrue(form.is_valid())

    def test_it_fails_update_verse_form_with_in_valid_data(self):
        form = UpdateVerseForm(instance=self.verse, data={})
        self.assertFalse(form.is_valid())


class UpdatePageFormValidationTest(TestCase):
    def setUp(self):
        self.page = PageFactory()
        self.Form = UpdatePageForm

        self.DEFAULT_DATA = {
            "image": "/media/verse_pictures/example.jpg",
            'page_number': 2,
            'sub_part': 3,
        }

    def test_verse_number_is_required(self):
        check_required(self, 'page_number')

    def test_verse_form_is_valid(self):
        form = UpdatePageForm(data=self.DEFAULT_DATA)
        x = form.is_valid()
        print(form.errors)
        self.assertTrue(form.is_valid())

    def test_verse_from_throw_error_if_provides_incomplete_data(self):
        form = UpdatePageForm(data={})
        self.assertFalse(form.is_valid())

    def test_verse_from_throw_error_if_email_is_email_is_already_exists(self):
        self.DEFAULT_DATA.pop('page_number')
        form = UpdatePageForm(data=self.DEFAULT_DATA)
        self.assertFalse(form.is_valid())

    def test_update_verse_form_with_valid_data(self):
        form = UpdatePageForm(instance=self.page, data=self.DEFAULT_DATA)
        self.assertTrue(form.is_valid())

    def test_it_fails_update_verse_form_with_in_valid_data(self):
        form = UpdatePageForm(instance=self.page, data={})
        self.assertFalse(form.is_valid())
