from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status, filters
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.recitations.models import Recitation
from apps.recitations.serializers_v1 import RecitationSerializer


class RecitationListAPIView(APIView):
    permission_classes = [TokenHasReadWriteScope]
    serializer_class = RecitationSerializer
    filter_backends = [filters.SearchFilter]
    search_fields = ['reciter__name', 'narration__name']

    def filter_queryset(self, queryset):
        for backend in list(self.filter_backends):
            queryset = backend().filter_queryset(self.request, queryset, self)
        return queryset

    def get_queryset(self):
        return Recitation.objects.all()

    def get(self, request, *args, **kwargs):
        the_filtered_qs = self.filter_queryset(self.get_queryset())
        serializer = self.serializer_class(the_filtered_qs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class RecitationDetailsView(APIView):
    permission_classes = [TokenHasReadWriteScope]

    def get(self, request, recitation_id):
        recitation = get_object_or_404(Recitation, pk=recitation_id)
        serializer = RecitationSerializer(recitation)
        return Response(serializer.data, status=status.HTTP_200_OK)
