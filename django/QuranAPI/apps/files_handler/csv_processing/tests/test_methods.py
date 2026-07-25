import pandas as pd
from apps.quran.csv_processing.process_book_file import process
from apps.quran.csv_processing.validate_book_columns import validate_fields
from django.core.files import File
from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import TestCase
from django.utils.translation import gettext_lazy as _

from apps.quran.factories import NarrationFactory, BookFactory, PageFactory
from apps.quran.models import BookCSVUpload, Verse


class ValidateBookFieldMethodTestCase(TestCase):

    def setUp(self) -> None:
        data = {'id': [1], 'jozz': [1], 'sura_no': [1], 'sura_name_en': ['Al-Fātiḥah'], 'sura_name_ar': ['الفَاتِحة'],
                'page': [1],
                'line_start': [2], 'line_end': [2], 'aya_no': [1], 'aya_text': ['‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏'],
                'aya_text_emlaey': ['بسم الله الرحمن الرحيم']
                }
        self.column = {
            'part_no': 1,
            'chapter_no': 2,
            'chapter_name_en': 3,
            'chapter_name_ar': 4,
            'page_no': 5,
            'line_start': 6,
            'line_end': 7,
            'aya_no': 8,
            'aya_text': 9,
            'aya_emlaey': 10,
        }
        self.row = pd.DataFrame(data)
        self.row = self.row.iloc[[0]]

    def test_validate_raise_error_if_part_number_is_not_number(self):
        row = self.row
        row.loc[0, 'jozz'] = 'abc'
        status, error_message = validate_fields(row, self.column)
        self.assertFalse(status)

    def test_validate_raise_message_if_part_number_is_not_number(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'jozz'] = 'abc'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('Part number must be integer'))

    def test_validate_raise_error_if_part_no_not_in_valid_range(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'jozz'] = '100'
        status, error_message = validate_fields(row, self.column)
        self.assertFalse(status)

    def test_validate_raise_message_if_part_number_not_in_a_valid_range(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'jozz'] = '2000'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('Part number must be  between 1 and 30'))

    def test_validate_raise_error_if_chapter_number_is_not_number(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'sura_no'] = 'abc'
        status, error_message = validate_fields(row, self.column)
        self.assertFalse(status)

    def test_validate_raise_message_if_chapter_number_is_not_number(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'sura_no'] = 'abc'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('Chapter number must be integer'))

    def test_validate_raise_error_if_chapter_no_not_in_valid_range(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'sura_no'] = '400'
        status, error_message = validate_fields(row, self.column)
        self.assertFalse(status)

    def test_validate_raise_message_if_chapter_number_not_in_a_valid_range(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'sura_no'] = '2000'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('Chapter number must be  between 1 and 114'))

    def test_validate_raise_message_if_sura_english_name_is_not_string(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'sura_name_en'] = 123
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('Sura name must be characters'))

    def test_it_raise_error_if_chapter_name_has_invalid_name(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'sura_name_en'] = 'Baqarah123'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('Sura name must be characters'))

    def test_validate_raise_message_if_sura_arabic_name_is_not_string(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'sura_name_ar'] = 123
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('Sura name must be characters'))

    def test_validate_raise_message_if_sura_arabic_name_is_not_valid(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'sura_name_ar'] = 'Baqarah123'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('Sura name must be characters'))

    def test_validate_raise_error_if_page_number_is_not_number(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'page'] = 'abc'
        status, error_message = validate_fields(row, self.column)
        self.assertFalse(status)

    def test_validate_raise_message_if_page_number_is_not_number(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'page'] = 'abc'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('Page number must be integer'))

    def test_validate_raise_error_if_line_start_is_not_number(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'line_start'] = 'abc'
        status, error_message = validate_fields(row, self.column)
        self.assertFalse(status)

    def test_validate_raise_message_if_line_start_is_not_number(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'line_start'] = 'abc'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('line start number must be integer'))

    def test_validate_raise_error_if_line_start_not_in_valid_range(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'line_start'] = '100'
        status, error_message = validate_fields(row, self.column)
        self.assertFalse(status)

    def test_validate_raise_message_if_line_start_not_in_a_valid_range(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'line_start'] = '2000'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('line start number must be  between 1 and 15'))

    def test_validate_raise_error_if_line_end_is_not_number(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'line_end'] = 'abc'
        status, error_message = validate_fields(row, self.column)
        self.assertFalse(status)

    def test_validate_raise_message_if_line_end_is_not_number(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'line_end'] = 'abc'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('line end number must be integer'))

    def test_validate_raise_error_if_line_end_not_in_valid_range(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'line_end'] = '100'
        status, error_message = validate_fields(row, self.column)
        self.assertFalse(status)

    def test_validate_raise_message_if_line_end_not_in_a_valid_range(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'line_end'] = '2000'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('line end number must be  between 1 and 15'))

    def test_validate_raise_error_if_aya_number_is_not_number(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'aya_no'] = 'abc'
        status, error_message = validate_fields(row, self.column)
        self.assertFalse(status)

    def test_validate_raise_message_if_aya_number_is_not_number(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'aya_no'] = 'abc'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('aya number must be integer'))

    def test_validate_raise_error_if_aya_number_not_in_valid_range(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'aya_no'] = '1000'
        status, error_message = validate_fields(row, self.column)
        self.assertFalse(status)

    def test_validate_raise_message_if_aya_number_not_in_a_valid_range(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'aya_no'] = '2000'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('aya number must be  between 1 and 15'))

    def test_validate_raise_message_if_aya_text_name_is_not_string(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'aya_text'] = '2000'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('aya text name must be characters'))

    def test_validate_raise_message_if_aya_emlay_text_name_is_not_string(self):
        row = self.row.copy(deep=True)
        row.loc[0, 'aya_text_emlaey'] = '2000'
        status, error_message = validate_fields(row, self.column)
        self.assertEqual(error_message, _('aya emlaey text must be characters only'))

    def test_it_pass_if_the_all_data_is_correct(self):
        status, error_message = validate_fields(self.row, self.column)
        self.assertTrue(status)

    def test_it_return_valid_row_message_if_data_is_valid(self):
        status, error_message = validate_fields(self.row, self.column)
        self.assertEqual(error_message, _('Valid row'))


class ProcessCSVBookMethodTestCase(TestCase):
    def setUp(self) -> None:
        narration = NarrationFactory(name='new narrations')
        self.book = BookFactory(narration=narration, name='hafs')
        file = File(open("apps/quran/book/tests/files/book.csv"))
        self.columns = {
            'part_no': 1,
            'chapter_no': 2,
            'chapter_name_en': 3,
            'chapter_name_ar': 4,
            'page_no': 5,
            'line_start': 6,
            'line_end': 7,
            'aya_no': 8,
            'aya_text': 9,
            'aya_emlaey': 10,
        }
        self.csv_book_upload = BookCSVUpload.objects.create(file=file, book=self.book, columns=self.columns)

    def test_it_raise_error_if_the_file_is_not_valid_csv_file(self):
        file = SimpleUploadedFile('text_file.txt', b'new content')
        csv_book_upload = BookCSVUpload.objects.create(file=file, book=self.book, columns=self.columns)

        with self.assertRaises(ValueError):
            process(csv_book_upload.pk)

    def test_it_raise_error_if_BookCSVUpload_does_not_exists(self):
        with self.assertRaises(ValueError):
            process(10000)

    def test_it_create_chapters_records_in_the_data_base(self):
        page = PageFactory(page_number=1, book=self.book, narration=self.book.narration)
        process(self.csv_book_upload.pk)
        self.assertNotEqual(Verse.objects.count(), 0)
