from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.recitations.models import Reciter
from apps.recitations.reciter.filters import ReciterAPIFilter
from apps.recitations.reciter.serializers_v1 import RecitersSerializer


class RecitersListAPIView(APIView):
    permission_classes = [TokenHasReadWriteScope]

    def get(self, request, *args, **kwargs):
        reciter = ReciterAPIFilter(request.GET, Reciter.objects.all())
        serializer = RecitersSerializer(reciter.qs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class RecitersDetailsAPIView(APIView):
    permission_classes = [TokenHasReadWriteScope]

    def get(self, request, reciter_id):
        reciter = get_object_or_404(Reciter, pk=reciter_id)
        serializer = RecitersSerializer(reciter)
        return Response(serializer.data, status=status.HTTP_200_OK)
