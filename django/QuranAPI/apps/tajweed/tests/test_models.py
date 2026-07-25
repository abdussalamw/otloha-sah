import inspect

from django import forms
from django.db import models
from django.test import TestCase
from django.utils.translation import gettext as _

from apps.narrations.models import Narration, Verse
from apps.tajweed.factories import TajweedBookFactory, RuleFactory, CharacterFactory
from apps.tajweed.models import Book, Rule, TranslatableModel, Character


class BookModelStructureTestCase(TestCase):
    def test_it_extends_django_model(self):
        self.assertTrue(issubclass(Book, TranslatableModel))

    def test_book_model_has_class_meta(self):
        self.assertIn('_meta', Book.__dict__)

    # Test ID

    def test_book_contains_id_attribute(self):
        self.assertTrue(hasattr(Book, 'id'))

    def test_id_field_is_instance_of_BigAutoField(self):
        field = Book._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    def test_id_field_is_primary_attribute_set_to_true(self):
        field = Book._meta.get_field('id')
        self.assertTrue(field.primary_key)

    # Test Name

    def test_if_book_has_translatable_variable(self):
        self.assertTrue(hasattr(Book, 'translatable'))

    def test_if_translatable_has_2_keys(self):
        self.assertEqual(len(Book.translatable), 2)

    def test_if_translatable_has_name_key(self):
        self.assertIn('name', Book.translatable.keys())

    def test_if_name_key_has_field_key(self):
        self.assertIn('field', Book.translatable['name'].keys())

    def test_if_field_key_in_name_key_of_translatable_extends_forms_CharField(self):
        self.assertEquals(Book.translatable['name']['field'], forms.CharField)

    def test_it_has_name_attribute(self):
        self.assertTrue(hasattr(Book, 'name'))

    def test_name_attribute_is_instance_of_json(self):
        field = Book._meta.get_field("name")
        self.assertIsInstance(field, models.JSONField)

    def test_name_field_has_verbose_name(self):
        field = Book._meta.get_field("name")
        self.assertIn('verbose_name', field.__dict__)

    def test_name_attribute_its_verbose_name_value_is_name(self):
        field = Book._meta.get_field('name')
        self.assertEqual(field.verbose_name, _('Name'))

    def test_name_field_has_null_value(self):
        field = Book._meta.get_field("name")
        self.assertIn('null', field.__dict__)

    def test_name_field_null_value_is_false(self):
        field = Book._meta.get_field("name")
        self.assertFalse(field.null)

    # Test Narration

    def test_model_has_narration_attribute(self):
        self.assertTrue(hasattr(Book, 'narration'))

    def test_narration_field_is_instance_of_foreign_Key(self):
        field = Book._meta.get_field('narration')
        self.assertIsInstance(field, models.ForeignKey)

    def test_narration_field_is_related_to_narration_model(self):
        field = Book._meta.get_field("narration")
        self.assertEquals(field.__dict__['related_model'], Narration)

    def test_narration_field_has_on_delete_attribute(self):
        field = Book._meta.get_field("narration")
        self.assertIn('on_delete', field.__dict__['remote_field'].__dict__)

    def test_narration_field_on_delete_attribute_is_set_null(self):
        field = Book._meta.get_field("narration")
        self.assertEquals(field.__dict__['remote_field'].__dict__['on_delete'], models.SET_NULL)

    def test_narration_field_has_null_value(self):
        field = Book._meta.get_field("narration")
        self.assertIn('null', field.__dict__)

    def test_narration_field_null_value_is_true(self):
        field = Book._meta.get_field("narration")
        self.assertTrue(field.null)

    def test_narration_field_has_blank_value(self):
        field = Book._meta.get_field("narration")
        self.assertIn('blank', field.__dict__)

    def test_narration_field_blank_value_is_true(self):
        field = Book._meta.get_field("narration")
        self.assertTrue(field.blank)

    # Test Author

    def test_if_translatable_has_author_key(self):
        self.assertIn('author', Book.translatable.keys())

    def test_if_author_key_has_field_key(self):
        self.assertIn('field', Book.translatable['author'].keys())

    def test_if_field_key_in_author_key_of_translatable_extends_forms_CharField(self):
        self.assertEquals(Book.translatable['author']['field'], forms.CharField)

    def test_it_has_author_attribute(self):
        self.assertTrue(hasattr(Book, 'author'))

    def test_author_attribute_is_instance_of_json(self):
        field = Book._meta.get_field("author")
        self.assertIsInstance(field, models.JSONField)

    def test_author_field_has_verbose_name(self):
        field = Book._meta.get_field("author")
        self.assertIn('verbose_name', field.__dict__)

    def test_author_attribute_its_verbose_name_value_is_author(self):
        field = Book._meta.get_field('author')
        self.assertEqual(field.verbose_name, _('Author'))

    # Test CSV_FORM

    def test_it_has_csv_form_attribute(self):
        self.assertTrue(hasattr(Book, 'csv_form'))

    def test_csv_form_field_value(self):
        self.assertEqual(Book.csv_form, 'apps.tajweed.forms.TajweedCSVForm')

    # Test CSV_PROCESS_FUNCTION

    def test_it_has_csv_process_function_attribute(self):
        self.assertTrue(hasattr(Book, 'csv_process_function'))

    def test_csv_process_function_field_value(self):
        self.assertEqual(Book.csv_process_function, 'apps.tajweed.tasks.process_csv_tajweed')

    # Test CSV_COLUMNS_INITIAL_VALUE

    def test_it_has_csv_columns_initial_value_attribute(self):
        self.assertTrue(hasattr(Book, 'csv_columns_initial_value'))

    def test_csv_columns_initial_value_field_value(self):
        self.assertEqual(Book.csv_columns_initial_value,
                         {
                             "word_text": None,
                             "character_number": None,
                             "character_text": None,
                             "verse_number": None,
                             "verse_text": None,
                             "chapter_number": None,
                             'rule': None,
                             'word_number': None,
                         }
                         )

    # Test __str__

    def test_book_has__str__attribute(self):
        self.assertTrue(hasattr(Book, '__str__'))

    def test__str__is_callable(self):
        self.assertTrue(callable(getattr(Book, '__str__')))

    def test__str__signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(Book.__str__)[0]
        self.assertEquals(actual_signature, expected_signature)


class BookModelTestCase(TestCase):
    def test___str___returns_name_if_available(self):
        book = TajweedBookFactory()
        self.assertEquals(str(book), _("{book} Book").format(book=book.translated_name))


class RuleModelStructureTestCase(TestCase):
    def test_it_extends_translatable_model(self):
        self.assertTrue(issubclass(Rule, TranslatableModel))

    def test_rule_model_has_class_meta(self):
        self.assertIn('_meta', Rule.__dict__)

    # Test ID

    def test_rule_contains_id_attribute(self):
        self.assertTrue(hasattr(Rule, 'id'))

    def test_id_field_is_instance_of_BigAutoField(self):
        field = Rule._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    def test_id_field_is_primary_attribute_set_to_true(self):
        field = Rule._meta.get_field('id')
        self.assertTrue(field.primary_key)

    # Test Rule_number

    def test_if_rule_has_rule_number_field(self):
        self.assertTrue(hasattr(Rule, 'rule_number'))

    def test_rule_number_field_is_instance_of_PositiveIntegerField(self):
        field = Rule._meta.get_field('rule_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_rule_number_field_has_blank_value(self):
        field = Rule._meta.get_field("rule_number")
        self.assertIn('blank', field.__dict__)

    def test_rule_number_field_is_set_blank_to_false(self):
        field = Rule._meta.get_field('rule_number')
        self.assertFalse(field.blank)

    def test_rule_number_field_has_null_value(self):
        field = Rule._meta.get_field("rule_number")
        self.assertIn('null', field.__dict__)

    def test_rule_number_field_is_set_null_to_false(self):
        field = Rule._meta.get_field('rule_number')
        self.assertFalse(field.null)

    def test_rule_number_attribute_has_verbose_name(self):
        field = Rule._meta.get_field('rule_number')
        self.assertIn('verbose_name', field.__dict__)

    def test_rule_number_field_verbose_name_attribute_is_Rule_Number(self):
        field = Rule._meta.get_field('rule_number')
        self.assertEqual(field.verbose_name, _('Rule Number'))

    # Test Name

    def test_if_rule_has_translatable_variable(self):
        self.assertTrue(hasattr(Rule, 'translatable'))

    def test_if_translatable_has_2_keys(self):
        self.assertEqual(len(Rule.translatable), 2)

    def test_if_translatable_has_name_key(self):
        self.assertIn('name', Rule.translatable.keys())

    def test_if_name_key_has_field_key(self):
        self.assertIn('field', Rule.translatable['name'].keys())

    def test_if_field_key_in_name_key_of_translatable_extends_forms_CharField(self):
        self.assertEquals(Rule.translatable['name']['field'], forms.CharField)

    def test_it_has_name_attribute(self):
        self.assertTrue(hasattr(Rule, 'name'))

    def test_name_attribute_is_instance_of_json(self):
        field = Rule._meta.get_field("name")
        self.assertIsInstance(field, models.JSONField)

    def test_name_field_has_verbose_name(self):
        field = Rule._meta.get_field("name")
        self.assertIn('verbose_name', field.__dict__)

    def test_name_attribute_its_verbose_name_value_is_name(self):
        field = Rule._meta.get_field('name')
        self.assertEqual(field.verbose_name, _('Name'))

    # Test Description

    def test_if_translatable_has_description_key(self):
        self.assertIn('description', Rule.translatable.keys())

    def test_if_field_key_in_description_key_of_translatable(self):
        self.assertIn('field', Rule.translatable['description'].keys())

    def test_if_field_key_in_description_key_of_translatable_extends_forms_CharField(self):
        self.assertEquals(Rule.translatable['description']['field'], forms.CharField)

    def test_if_widget_key_in_description_key_of_translatable(self):
        self.assertIn('widget', Rule.translatable['description'].keys())

    def test_if_widget_key_in_description_key_of_translatable_extends_forms_Textarea(self):
        self.assertEquals(Rule.translatable['description']['widget'], forms.Textarea)

    def test_rule_model_has_description_field(self):
        self.assertTrue(hasattr(Rule, 'description'))

    def test_description_field_is_instance_of_JSONField_or_not(self):
        field = Rule._meta.get_field('description')
        self.assertIsInstance(field, models.JSONField)

    def test_description_field_has_null_value(self):
        field = Rule._meta.get_field("description")
        self.assertIn('null', field.__dict__)

    def test_description_field_null_value_is_true(self):
        field = Rule._meta.get_field("description")
        self.assertTrue(field.null)

    def test_description_field_has_blank_value(self):
        field = Rule._meta.get_field("description")
        self.assertIn('blank', field.__dict__)

    def test_description_field_blank_value_is_true(self):
        field = Rule._meta.get_field("description")
        self.assertTrue(field.blank)

    def test_description_field_has_verbose_name(self):
        field = Rule._meta.get_field("description")
        self.assertIn('verbose_name', field.__dict__)

    def test_description_field_its_verbose_name_value_is_description(self):
        field = Rule._meta.get_field('description')
        self.assertEqual(field.verbose_name, _('Description'))

    # Test Color

    def test_if_red_variable_exists(self):
        self.assertTrue(hasattr(Rule, 'RED'))

    def test_if_green_variable_exists(self):
        self.assertTrue(hasattr(Rule, 'GREEN'))

    def test_if_blue_variable_exists(self):
        self.assertTrue(hasattr(Rule, 'BLUE'))

    def test_if_yellow_variable_exists(self):
        self.assertTrue(hasattr(Rule, 'Yellow'))

    def test_if_orange_variable_exists(self):
        self.assertTrue(hasattr(Rule, 'ORANGE'))

    def test_if_black_variable_exists(self):
        self.assertTrue(hasattr(Rule, 'BLACK'))

    def test_if_white_variable_exists(self):
        self.assertTrue(hasattr(Rule, 'WHITE'))

    def test_if_pink_variable_exists(self):
        self.assertTrue(hasattr(Rule, 'PINK'))

    def test_if_brown_variable_exists(self):
        self.assertTrue(hasattr(Rule, 'BROWN'))

    def test_if_grey_variable_exists(self):
        self.assertTrue(hasattr(Rule, 'GREY'))

    def test_if_navy_variable_exists(self):
        self.assertTrue(hasattr(Rule, 'NAVY'))

    def test_if_aqua_variable_exists(self):
        self.assertTrue(hasattr(Rule, 'AQUA'))

    def test_if_colors_variable_exists(self):
        self.assertTrue(hasattr(Rule, 'COLORS'))

    def test_if_len_of_origins_is_12(self):
        self.assertEqual(len(Rule.COLORS), 12)

    def test_if_colors_returns_tuple_of_tuples(self):
        self.assertEqual(Rule.COLORS, (
            ('red', _('Red')),
            ('grn', _('Green')),
            ('blu', _('Blue')),
            ('ylw', _('Yellow')),
            ('org', _('Orange')),
            ('blk', _('Black')),
            ('wht', _('White')),
            ('pnk', _('Pink')),
            ('brw', _('Brown')),
            ('gry', _('Grey')),
            ('nvy', _('Navy')),
            ('aqu', _('Aqua'))
        )
                         )

    def test_if_colors_has_red_value(self):
        self.assertEqual(Rule.COLORS[0][0], 'red')

    def test_if_colors_has_green_value(self):
        self.assertEqual(Rule.COLORS[1][0], 'grn')

    def test_if_colors_has_blue_value(self):
        self.assertEqual(Rule.COLORS[2][0], 'blu')

    def test_if_colors_has_yellow_value(self):
        self.assertEqual(Rule.COLORS[3][0], 'ylw')

    def test_if_colors_has_orange_value(self):
        self.assertEqual(Rule.COLORS[4][0], 'org')

    def test_if_colors_has_black_value(self):
        self.assertEqual(Rule.COLORS[5][0], 'blk')

    def test_if_colors_has_white_value(self):
        self.assertEqual(Rule.COLORS[6][0], 'wht')

    def test_if_colors_has_pink_value(self):
        self.assertEqual(Rule.COLORS[7][0], 'pnk')

    def test_if_colors_has_brown_value(self):
        self.assertEqual(Rule.COLORS[8][0], 'brw')

    def test_if_colors_has_grey_value(self):
        self.assertEqual(Rule.COLORS[9][0], 'gry')

    def test_if_colors_has_navy_value(self):
        self.assertEqual(Rule.COLORS[10][0], 'nvy')

    def test_if_colors_has_aqua_value(self):
        self.assertEqual(Rule.COLORS[11][0], 'aqu')

    def test_if_color_attribute_exists(self):
        self.assertTrue(hasattr(Rule, 'color'))

    def test_colors_attribute_is_instance_of_char_field(self):
        field = Rule._meta.get_field("color")
        self.assertIsInstance(field, models.CharField)

    def test_colors_attribute_has_max_length_value(self):
        field = Rule._meta.get_field("color")
        self.assertIn('max_length', field.__dict__)

    def test_colors_attribute_max_length_value_is_50(self):
        field = Rule._meta.get_field("color")
        self.assertEquals(field.max_length, 50)

    def test_colors_attribute_has_colors_choices(self):
        field = Rule._meta.get_field("color")
        self.assertIsNotNone(field.choices)

    def test_colors_attribute_value_is_colors_choices_variable(self):
        field = Rule._meta.get_field("color")
        self.assertEquals(Rule.COLORS, field.choices)

    # Test Tajweed_book

    def test_model_has_book_attribute(self):
        self.assertTrue(hasattr(Rule, 'tajweed_book'))

    def test_tajweed_book_field_is_instance_of_foreign_Key(self):
        field = Rule._meta.get_field('tajweed_book')
        self.assertIsInstance(field, models.ForeignKey)

    def test_tajweed_book_field_is_related_to_tajweed_book_model(self):
        field = Rule._meta.get_field("tajweed_book")
        self.assertEquals(field.__dict__['related_model'], Book)

    def test_tajweed_book_field_has_on_delete_attribute(self):
        field = Rule._meta.get_field("tajweed_book")
        self.assertIn('on_delete', field.__dict__['remote_field'].__dict__)

    def test_tajweed_book_field_on_delete_attribute_is_cascade(self):
        field = Rule._meta.get_field("tajweed_book")
        self.assertEquals(field.__dict__['remote_field'].__dict__['on_delete'], models.CASCADE)

    # Test __str__

    def test_rule_has__str__attribute(self):
        self.assertTrue(hasattr(Rule, '__str__'))

    def test__str__is_callable(self):
        self.assertTrue(callable(getattr(Rule, '__str__')))

    def test__str__signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(Rule.__str__)[0]
        self.assertEquals(actual_signature, expected_signature)


class RuleModelTestCase(TestCase):

    def test___str___returns_name_tajweed_book_if_available(self):
        rule = RuleFactory(tajweed_book=TajweedBookFactory())
        self.assertEquals(str(rule), _("Rule: {rule}, Rule Number: {rule_number}").format(
            rule=rule.translated_name,
            rule_number=rule.rule_number,
        ))


class CharacterModelStructureTestCase(TestCase):
    def test_it_extends_django_model(self):
        self.assertTrue(issubclass(Character, models.Model))

    def test_character_model_has_class_meta(self):
        self.assertIn('_meta', Character.__dict__)

    # Test ID

    def test_character_contains_id_attribute(self):
        self.assertTrue(hasattr(Character, 'id'))

    def test_id_field_is_instance_of_BigAutoField(self):
        field = Character._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    def test_id_field_is_primary_attribute_set_to_true(self):
        field = Character._meta.get_field('id')
        self.assertTrue(field.primary_key)

    # Test Character_Text

    def test_it_has_character_text_attribute(self):
        self.assertTrue(hasattr(Character, 'character_text'))

    def test_character_text_field_is_instance_of_CharField_or_not(self):
        field = Character._meta.get_field('character_text')
        self.assertIsInstance(field, models.CharField)

    def test_character_text_attribute_has_max_length_value(self):
        field = Character._meta.get_field("character_text")
        self.assertIn('max_length', field.__dict__)

    def test_character_text_attribute_max_length_value_is_5000(self):
        field = Character._meta.get_field("character_text")
        self.assertEquals(field.max_length, 5000)

    def test_character_text_field_has_verbose_name(self):
        field = Character._meta.get_field("character_text")
        self.assertIn('verbose_name', field.__dict__)

    def test_character_text_field_its_verbose_name_value_is_character_text(self):
        field = Character._meta.get_field('character_text')
        self.assertEqual(field.verbose_name, _('Character Text'))

    # Test Character_number

    def test_if_character_has_character_number_field(self):
        self.assertTrue(hasattr(Character, 'character_number'))

    def test_character_number_field_is_instance_of_PositiveIntegerField(self):
        field = Character._meta.get_field('character_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_character_number_field_has_blank_value(self):
        field = Character._meta.get_field("character_number")
        self.assertIn('blank', field.__dict__)

    def test_character_number_field_is_set_blank_to_false(self):
        field = Character._meta.get_field('character_number')
        self.assertFalse(field.blank)

    def test_character_number_field_has_null_value(self):
        field = Character._meta.get_field("character_number")
        self.assertIn('null', field.__dict__)

    def test_character_number_field_is_set_null_to_false(self):
        field = Character._meta.get_field('character_number')
        self.assertFalse(field.null)

    def test_character_number_field_has_verbose_name(self):
        field = Character._meta.get_field('character_number')
        self.assertIn('verbose_name', field.__dict__)

    def test_character_number_field_verbose_name_attribute_is_Character_Number(self):
        field = Character._meta.get_field('character_number')
        self.assertEqual(field.verbose_name, _('Character Number'))

    # Test Word_Text

    def test_it_has_word_text_attribute(self):
        self.assertTrue(hasattr(Character, 'word_text'))

    def test_word_text_field_is_instance_of_charfield(self):
        field = Character._meta.get_field('word_text')
        self.assertIsInstance(field, models.CharField)

    def test_word_text_attribute_has_max_length_value(self):
        field = Character._meta.get_field("word_text")
        self.assertIn('max_length', field.__dict__)

    def test_word_text_attribute_max_length_value_is_1000(self):
        field = Character._meta.get_field("word_text")
        self.assertEquals(field.max_length, 1000)

    def test_word_text_field_has_verbose_name(self):
        field = Character._meta.get_field("word_text")
        self.assertIn('verbose_name', field.__dict__)

    def test_word_text_field_its_verbose_name_value_is_word_text(self):
        field = Character._meta.get_field('word_text')
        self.assertEqual(field.verbose_name, _('Word Text'))

    # Test Word_number

    def test_if_character_has_word_number_field(self):
        self.assertTrue(hasattr(Character, 'word_number'))

    def test_word_number_field_is_instance_of_PositiveIntegerField(self):
        field = Character._meta.get_field('word_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_word_number_field_has_blank_value(self):
        field = Character._meta.get_field("word_number")
        self.assertIn('blank', field.__dict__)

    def test_word_number_field_is_set_blank_to_false(self):
        field = Character._meta.get_field('word_number')
        self.assertFalse(field.blank)

    def test_word_number_field_has_null_value(self):
        field = Character._meta.get_field("word_number")
        self.assertIn('null', field.__dict__)

    def test_word_number_field_is_set_null_to_false(self):
        field = Character._meta.get_field('word_number')
        self.assertFalse(field.null)

    def test_word_number_field_has_verbose_name(self):
        field = Character._meta.get_field('word_number')
        self.assertIn('verbose_name', field.__dict__)

    def test_word_number_field_verbose_name_attribute_is_Verse_Number(self):
        field = Character._meta.get_field('word_number')
        self.assertEqual(field.verbose_name, _('Word Number'))

    # Test Rule

    def test_character_model_has_rule_field(self):
        self.assertTrue(hasattr(Character, 'rule'))

    def test_rule_text_field_is_instance_of_textfield(self):
        field = Character._meta.get_field('rule_text')
        self.assertIsInstance(field, models.TextField)

    def test_rule_text_field_has_null_value(self):
        field = Character._meta.get_field("rule_text")
        self.assertIn('null', field.__dict__)

    def test_rule_text_field_null_value_is_true(self):
        field = Character._meta.get_field("rule_text")
        self.assertTrue(field.null)

    def test_rule_text_field_has_blank_value(self):
        field = Character._meta.get_field("rule_text")
        self.assertIn('blank', field.__dict__)

    def test_rule_text_field_blank_value_is_true(self):
        field = Character._meta.get_field("rule_text")
        self.assertTrue(field.blank)

    def test_rule_text_field_has_verbose_name(self):
        field = Character._meta.get_field("rule_text")
        self.assertIn('verbose_name', field.__dict__)

    def test_rule_text_field_its_verbose_name_value_is_rule_text(self):
        field = Character._meta.get_field('rule_text')
        self.assertEqual(field.verbose_name, _('Rule Text'))

    def test_if_character_has_verse_number_field(self):
        self.assertTrue(hasattr(Character, 'verse_number'))

    def test_verse_number_field_is_instance_of_PositiveIntegerField(self):
        field = Character._meta.get_field('verse_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_verse_number_field_has_blank_value(self):
        field = Character._meta.get_field("verse_number")
        self.assertIn('blank', field.__dict__)

    def test_verse_number_field_is_set_blank_to_false(self):
        field = Character._meta.get_field('verse_number')
        self.assertFalse(field.blank)

    def test_verse_number_field_has_null_value(self):
        field = Character._meta.get_field("verse_number")
        self.assertIn('null', field.__dict__)

    def test_verse_number_field_is_set_null_to_false(self):
        field = Character._meta.get_field('verse_number')
        self.assertFalse(field.null)

    def test_verse_number_field_has_verbose_name(self):
        field = Character._meta.get_field('verse_number')
        self.assertIn('verbose_name', field.__dict__)

    def test_verse_number_field_verbose_name_attribute_is_Verse_Number(self):
        field = Character._meta.get_field('verse_number')
        self.assertEqual(field.verbose_name, _('Verse Number'))

    # Test Chapter_number

    def test_if_it_contains_chapter_number(self):
        self.assertTrue(hasattr(Character, 'chapter_number'))

    def test_chapter_number_field_is_instance_of_PositiveIntegerField(self):
        field = Character._meta.get_field('chapter_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_chapter_number_field_has_blank_value(self):
        field = Character._meta.get_field("chapter_number")
        self.assertIn('blank', field.__dict__)

    def test_chapter_number_field_is_set_blank_to_false(self):
        field = Character._meta.get_field('chapter_number')
        self.assertFalse(field.blank)

    def test_chapter_number_field_has_null_value(self):
        field = Character._meta.get_field("chapter_number")
        self.assertIn('null', field.__dict__)

    def test_chapter_number_field_is_set_null_to_false(self):
        field = Character._meta.get_field('chapter_number')
        self.assertFalse(field.null)

    def test_chapter_number_attribute_has_verbose_name(self):
        field = Character._meta.get_field('chapter_number')
        self.assertIn('verbose_name', field.__dict__)

    def test_chapter_number_field_verbose_name_attribute_is_Chapter_Number(self):
        field = Character._meta.get_field('chapter_number')
        self.assertEqual(field.verbose_name, _('Chapter Number'))

    # Test Tajweed_book

    def test_model_has_book_attribute(self):
        self.assertTrue(hasattr(Character, 'book'))

    def test_book_field_is_instance_of_foreign_Key(self):
        field = Character._meta.get_field('book')
        self.assertIsInstance(field, models.ForeignKey)

    def test_book_field_is_related_to_book_model(self):
        field = Character._meta.get_field("book")
        self.assertEquals(field.__dict__['related_model'], Book)

    def test_book_field_has_blank_value(self):
        field = Character._meta.get_field("book")
        self.assertIn('blank', field.__dict__)

    def test_book_field_is_set_blank_to_true(self):
        field = Character._meta.get_field('book')
        self.assertTrue(field.blank)

    def test_book_field_has_null_value(self):
        field = Character._meta.get_field("book")
        self.assertIn('null', field.__dict__)

    def test_book_field_is_set_null_to_true(self):
        field = Character._meta.get_field('book')
        self.assertTrue(field.null)

    def test_book_field_has_on_delete_attribute(self):
        field = Character._meta.get_field("book")
        self.assertIn('on_delete', field.__dict__['remote_field'].__dict__)

    def test_book_field_on_delete_attribute_is_set_null(self):
        field = Character._meta.get_field("book")
        self.assertEquals(field.__dict__['remote_field'].__dict__['on_delete'], models.SET_NULL)

    def test_book_attribute_has_verbose_name(self):
        field = Character._meta.get_field('book')
        self.assertIn('verbose_name', field.__dict__)

    def test_book_field_verbose_name_attribute_is_Chapter_Number(self):
        field = Character._meta.get_field('book')
        self.assertEqual(field.verbose_name, _('Book'))

    # Test Tajweed_rule

    def test_model_has_rule_attribute(self):
        self.assertTrue(hasattr(Character, 'rule'))

    def test_rule_field_is_instance_of_foreign_Key(self):
        field = Character._meta.get_field('rule')
        self.assertIsInstance(field, models.ForeignKey)

    def test_rule_field_is_related_to_rule_model(self):
        field = Character._meta.get_field("rule")
        self.assertEquals(field.__dict__['related_model'], Rule)

    def test_rule_field_has_blank_value(self):
        field = Character._meta.get_field("rule")
        self.assertIn('blank', field.__dict__)

    def test_rule_field_is_set_blank_to_true(self):
        field = Character._meta.get_field('rule')
        self.assertTrue(field.blank)

    def test_rule_field_has_null_value(self):
        field = Character._meta.get_field("rule")
        self.assertIn('null', field.__dict__)

    def test_rule_field_is_set_null_to_true(self):
        field = Character._meta.get_field('rule')
        self.assertTrue(field.null)

    def test_rule_attribute_has_verbose_name(self):
        field = Character._meta.get_field('rule')
        self.assertIn('verbose_name', field.__dict__)

    def test_rule_field_verbose_name_attribute_is_Chapter_Number(self):
        field = Character._meta.get_field('rule')
        self.assertEqual(field.verbose_name, _('Rule'))

    def test_rule_field_has_on_delete_attribute(self):
        field = Character._meta.get_field("rule")
        self.assertIn('on_delete', field.__dict__['remote_field'].__dict__)

    def test_rule_field_on_delete_attribute_is_set_null(self):
        field = Character._meta.get_field("rule")
        self.assertEquals(field.__dict__['remote_field'].__dict__['on_delete'], models.SET_NULL)

    # Test Tajweed_verse

    def test_model_has_verse_attribute(self):
        self.assertTrue(hasattr(Character, 'verse'))

    def test_verse_field_is_instance_of_foreign_Key(self):
        field = Character._meta.get_field('verse')
        self.assertIsInstance(field, models.ForeignKey)

    def test_verse_field_is_related_to_verse_model(self):
        field = Character._meta.get_field("verse")
        self.assertEquals(field.__dict__['related_model'], Verse)

    def test_verse_field_has_blank_value(self):
        field = Character._meta.get_field("verse")
        self.assertIn('blank', field.__dict__)

    def test_verse_field_is_set_blank_to_true(self):
        field = Character._meta.get_field('verse')
        self.assertTrue(field.blank)

    def test_verse_field_has_null_value(self):
        field = Character._meta.get_field("verse")
        self.assertIn('null', field.__dict__)

    def test_verse_field_is_set_null_to_true(self):
        field = Character._meta.get_field('verse')
        self.assertTrue(field.null)

    def test_verse_attribute_has_verbose_name(self):
        field = Character._meta.get_field('verse')
        self.assertIn('verbose_name', field.__dict__)

    def test_verse_field_verbose_name_attribute_is_Chapter_Number(self):
        field = Character._meta.get_field('verse')
        self.assertEqual(field.verbose_name, _('Verse'))

    def test_verse_field_has_on_delete_attribute(self):
        field = Character._meta.get_field("verse")
        self.assertIn('on_delete', field.__dict__['remote_field'].__dict__)

    def test_verse_field_on_delete_attribute_is_set_null(self):
        field = Character._meta.get_field("verse")
        self.assertEquals(field.__dict__['remote_field'].__dict__['on_delete'], models.SET_NULL)

    # Test __str__

    def test_character_has__str__attribute(self):
        self.assertTrue(hasattr(Character, '__str__'))

    def test__str__is_callable(self):
        self.assertTrue(callable(getattr(Character, '__str__')))

    def test__str__signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(Character.__str__)[0]
        self.assertEquals(actual_signature, expected_signature)


class CharacterModelTestCase(TestCase):

    def test___str___returns_name_word_if_available(self):
        character = CharacterFactory(word_number=1)
        self.assertEquals(str(character), _("Character {character}").format(character=character.character_text))
