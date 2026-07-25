import os
import uuid
from wsgiref.util import FileWrapper

from django.conf import settings
from django.http import StreamingHttpResponse, Http404, FileResponse
from django.utils.translation import gettext as _
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.records.models import Record
from apps.records.serializers import BaseRecordSerializer, NewRecordSerializer


class RecordsAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = BaseRecordSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class RecordChunkUploadAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.chunk_num = None
        self.total_chunks = None
        self.filename = None
        self.extension = None
        self.temp_path = None

    def get_temp_path(self):

        root = settings.MEDIA_ROOT if self.request.data.get('private', "false") == 'false' else settings.UPLOAD_ROOT

        self.temp_path = os.path.join(root, 'records', 'temp', str(self.filename))
        if not os.path.exists(self.temp_path):
            os.makedirs(self.temp_path)
        return self.temp_path

    def get_destination_path(self):
        root = settings.MEDIA_ROOT if self.request.data.get('private', "false") == 'false' else settings.UPLOAD_ROOT
        file_uuid = str(uuid.uuid4())
        dir_path = os.path.join(root, 'records', file_uuid)
        if not os.path.exists(dir_path):
            os.makedirs(dir_path)

        filename = f"{self.filename}.{self.extension}"
        file_path = f"{dir_path}/{filename}"
        return dir_path, filename, file_path, file_uuid

    def write_chunks(self):
        chunk = self.request.data.get('record')
        self.chunk_num = int(self.request.data.get('chunk_num', 0))
        self.total_chunks = int(self.request.data.get('total_chunks', 1))
        self.filename = self.request.data.get('filename', None).split('.')[0]
        self.extension = self.request.data.get('extension', None)
        unique_filename = f"chunk_{self.chunk_num}.part"
        self.temp_path = self.get_temp_path()
        with open(f"{self.temp_path}/{unique_filename}", 'wb') as destination:
            for chunk_data in chunk.chunks():
                destination.write(chunk_data)

    def merge_chunks(self):
        """
        Merges all the uploaded chunks into a single file.
        """
        dir_path, filename, file_path, file_uuid = self.get_destination_path()

        with open(file_path, 'wb') as destination:
            for i in range(self.total_chunks):
                part_file = f"{self.temp_path}/chunk_{i}.part"
                with open(part_file, 'rb') as source:
                    destination.write(source.read())
                os.remove(part_file)
            os.rmdir(self.temp_path)
        return dir_path, filename, file_path, file_uuid

    def post(self, request, *args, **kwargs):
        self.write_chunks()

        if self.chunk_num == self.total_chunks - 1:
            dir_path, filename, file_path, file_uuid = self.merge_chunks()

            serializer = NewRecordSerializer(data={
                "record": f"records/{file_uuid}/{filename}",
                "uuid": file_uuid,
                "private": request.data.get("private")
            })

            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)

            return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)
        return Response({'status': 'chunk_uploaded'})


class RecordStreamFileAPIView(APIView):

    def get(self, request, file_uuid, *args, **kwargs):
        record = get_object_or_404(Record, uuid=file_uuid)

        root = settings.UPLOAD_ROOT if record.private else settings.MEDIA_ROOT
        file_path = os.path.join(root, str(record.record))
        if not os.path.exists(file_path):
            return Response({"detail": "File not found."}, status=status.HTTP_404_NOT_FOUND)

        file_wrapper = FileWrapper(open(file_path, 'rb'))
        file_mime_type = 'application/octet-stream'

        response = StreamingHttpResponse(file_wrapper, content_type=file_mime_type)
        response['Content-Disposition'] = f'attachment; filename="{os.path.basename(file_path)}"'
        response['Content-Length'] = os.path.getsize(file_path)

        return response


class RecordDownloadFileAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, file_uuid, *args, **kwargs):
        record = get_object_or_404(Record, uuid=file_uuid)

        # if record.private and request.user not in record.allowed_users.all():
        #     raise Http404(_("Record not found"))

        root = settings.UPLOAD_ROOT if record.private else settings.MEDIA_ROOT
        file_path = os.path.join(root, str(record.record))
        if not os.path.exists(file_path):
            return Response({"detail": _("File not found.")}, status=status.HTTP_404_NOT_FOUND)

        response = FileResponse(open(file_path, 'rb'), as_attachment=True, filename=os.path.basename(file_path))
        return response
