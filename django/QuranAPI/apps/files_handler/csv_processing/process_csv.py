import importlib

from app.celery import app
from apps.files_handler.models import File


def get_csv_processor(csv):
    csv_processing_function = csv.content_object.csv_process_function
    split_csv_processing_function = csv_processing_function.split('.')
    function_name = split_csv_processing_function[-1:][0]
    module_name = split_csv_processing_function[:-1]
    processing_function = getattr(importlib.import_module('.'.join(module_name)), function_name)
    return processing_function(csv.pk)


@app.task
def execute(pk):
    csv_file_model = File.objects.get(pk=pk)

    # Run Processing
    get_csv_processor(csv=csv_file_model)

    # Mark File as Processed
    csv_file_model.is_processed = True
    csv_file_model.status = csv_file_model.STATUS_PROCESSED
    csv_file_model.save()
