from django.contrib.postgres.search import SearchVector
from django.db import migrations


def compute_search_vector(apps, schema_editor):
    Chapter = apps.get_model("chapters", "Chapter")
    Chapter.objects.update(search_vector=SearchVector("searchable_name"))


class Migration(migrations.Migration):

    dependencies = [
        ("chapters", "0004_chapter_search_vector"),
    ]

    operations = [
        migrations.RunSQL(
            sql="""
            CREATE TRIGGER search_vector_trigger
            BEFORE INSERT OR UPDATE OF searchable_name, search_vector
            ON chapters_chapter
            FOR EACH ROW EXECUTE PROCEDURE
            tsvector_update_trigger(
                search_vector, 'pg_catalog.english', searchable_name
            );
            UPDATE chapters_chapter SET search_vector = NULL;
            """,
            reverse_sql="""
            DROP TRIGGER IF EXISTS search_vector_trigger
            ON chapters_chapter;
            """,
        ),
        migrations.RunPython(
            compute_search_vector, reverse_code=migrations.RunPython.noop
        ),
    ]