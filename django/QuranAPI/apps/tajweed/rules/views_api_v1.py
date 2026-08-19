from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.tajweed.filters import RuleFilter
from apps.tajweed.models import Rule
from apps.tajweed.serializers import RuleSerializer


class RulesListingAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        rules = RuleFilter(request.GET, Rule.objects.all())
        serializer = RuleSerializer(rules.qs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class RuleDetailsAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, rule_id):
        rule = get_object_or_404(Rule, pk=rule_id)
        serializer = RuleSerializer(rule)
        return Response(serializer.data, status=status.HTTP_200_OK)
