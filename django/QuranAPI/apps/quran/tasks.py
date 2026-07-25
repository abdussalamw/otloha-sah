from app.celery import app
from apps.quran.images_processing.process_book import ProcessBookImages


@app.task
def process_zip_file(pk):
    ProcessBookImages().execute(book_file_id=pk)
