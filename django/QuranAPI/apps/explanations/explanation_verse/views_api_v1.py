from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.explanations.explanation_verse.filters import ExplanationVerseAPIFilter
from apps.explanations.models import ExplanationVerse, Explanation
from apps.explanations.serializers import ExplanationVerseSerializer


class ExplanationVerseListingView(APIView):
    permission_classes = [TokenHasReadWriteScope]

    def get(self, request, explanation_id, *args, **kwargs):
        explanation = get_object_or_404(Explanation, id=explanation_id)
        queryset = ExplanationVerseAPIFilter(request.GET, explanation.explanationverse_set.all()).qs
        serializer = ExplanationVerseSerializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class ExplanationVerseDetailsView(APIView):
    permission_classes = [TokenHasReadWriteScope]

    def get(self, request, explanation_id, explanation_verse_id):
        get_object_or_404(Explanation, id=explanation_id)
        explanation_verse = get_object_or_404(ExplanationVerse, pk=explanation_verse_id)
        serializer = ExplanationVerseSerializer(explanation_verse)
        return Response(serializer.data, status=status.HTTP_200_OK)
