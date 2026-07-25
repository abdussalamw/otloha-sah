import importlib

import requests
from django.core import files
from django.core.files.base import ContentFile

from app.celery import app
from apps.files_handler.models import File


def get_file_processor(file, process_name, method_name):
    processing_function = file.content_object.FILE_PROCESSORS[process_name]['method']
    split_processing_function = processing_function.split('.')
    function_name = split_processing_function[-1:][0]
    module_name = split_processing_function[:-1]
    processing_function = getattr(importlib.import_module('.'.join(module_name)), function_name)
    return processing_function(file.pk)


@app.task
def execute(pk, process_name, method_name):
    file_model = File.objects.get(pk=pk)
    # Run Processing
    get_file_processor(file_model, process_name, method_name)

    # Mark File as Processed
    file_model.is_processed = True
    file_model.status = file_model.STATUS_PROCESSED
    file_model.save()


@app.task
def download_from_url(pk, url):
    instance = File.objects.get(pk=pk)
    response = requests.get(url)
    filename = url.split('/')[-1]
    file = files.File(ContentFile(response.content), filename)
    instance.file = file
    instance.save()
