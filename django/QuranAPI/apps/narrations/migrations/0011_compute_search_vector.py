from django.contrib.postgres.search import SearchVector
from django.db import migrations


def compute_search_vector(apps, schema_editor):
    Verse = apps.get_model("narrations", "Verse")
    Verse.objects.update(search_vector=SearchVector("searchable_text"))


class Migration(migrations.Migration):

    dependencies = [
        ("narrations", "0010_verse_search_vector"),
    ]

    operations = [
        migrations.RunSQL(
            sql="""
            CREATE TRIGGER search_vector_trigger
            BEFORE INSERT OR UPDATE OF searchable_text, text, search_vector
            ON narrations_verse
            FOR EACH ROW EXECUTE PROCEDURE
            tsvector_update_trigger(
                search_vector, 'pg_catalog.english', searchable_text, text
            );
            UPDATE narrations_verse SET search_vector = NULL;
            """,
            reverse_sql="""
            DROP TRIGGER IF EXISTS search_vector_trigger
            ON narrations_verse;
            """,
        ),
        migrations.RunPython(
            compute_search_vector, reverse_code=migrations.RunPython.noop
        ),
    ]