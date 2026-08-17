from django.contrib.postgres.search import SearchVector
from django.db import migrations


def is_postgresql(schema_editor):
    return schema_editor.connection.vendor == 'postgresql'


def create_search_vector_trigger(apps, schema_editor):
    if not is_postgresql(schema_editor):
        return
    schema_editor.execute(
        """
        CREATE TRIGGER search_vector_trigger
        BEFORE INSERT OR UPDATE OF searchable_text, text, search_vector
        ON narrations_verse
        FOR EACH ROW EXECUTE PROCEDURE
        tsvector_update_trigger(
            search_vector, 'pg_catalog.english', searchable_text, text
        );
        UPDATE narrations_verse SET search_vector = NULL;
        """
    )


def remove_search_vector_trigger(apps, schema_editor):
    if not is_postgresql(schema_editor):
        return
    schema_editor.execute(
        """
        DROP TRIGGER IF EXISTS search_vector_trigger
        ON narrations_verse;
        """
    )


def compute_search_vector(apps, schema_editor):
    if not is_postgresql(schema_editor):
        return
    Verse = apps.get_model('narrations', 'Verse')
    Verse.objects.update(search_vector=SearchVector('searchable_text'))


class Migration(migrations.Migration):

    dependencies = [
        ('narrations', '0010_verse_search_vector'),
    ]

    operations = [
        migrations.RunPython(
            create_search_vector_trigger,
            reverse_code=remove_search_vector_trigger,
        ),
        migrations.RunPython(
            compute_search_vector,
            reverse_code=migrations.RunPython.noop,
        ),
    ]
