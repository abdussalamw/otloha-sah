from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.explanations.filters import ExplanationAPIFilter
from apps.explanations.models import Explanation
from apps.explanations.serializers import ExplanationSerializer


class ExplanationListingView(APIView):
    permission_classes = [TokenHasReadWriteScope]

    def get(self, request, *args, **kwargs):
        explanations = ExplanationAPIFilter(request.GET, Explanation.objects.all()).qs
        serializer = ExplanationSerializer(explanations, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class ExplanationDetailsView(APIView):
    permission_classes = [TokenHasReadWriteScope]

    def get(self, request, explanation_id):
        explanation = get_object_or_404(Explanation, pk=explanation_id)
        serializer = ExplanationSerializer(explanation)
        return Response(serializer.data, status=status.HTTP_200_OK)
