from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.viewsets import ViewSet

from apps.ads.models import Ad
from apps.ads.serializers.serializers import AdSerializer


class AdsViewSet(ViewSet):
    permission_classes = []
    authentication_classes = []

    def list(self, request):
        ads = Ad.objects.all()
        serializer = AdSerializer(ads, many=True)
        return Response(serializer.data)
