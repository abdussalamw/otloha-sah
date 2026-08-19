from django.http import JsonResponse
from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.quran.page.serializers import PageSerializer
from apps.quran.models import Page
from .filters import PageAPIFilter


class PagesListOrDownloadAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        pages = PageAPIFilter(request.GET, Page.objects.all())
        serializer = PageSerializer(pages.qs, many=True)

        if request.GET.get("download", None) is None:
            return Response(serializer.data, status=status.HTTP_200_OK)

        return JsonResponse(
            serializer.data,
            safe=False,
            content_type="application/json",
            headers={'Content-Disposition': "attachment; filename=pages.json"}
        )


class PagesDetailAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, page_id):
        page = get_object_or_404(Page, pk=page_id)
        serializer = PageSerializer(page)
        return Response(serializer.data, status=status.HTTP_200_OK)
