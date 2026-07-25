from django.core.exceptions import ObjectDoesNotExist
from django.db.models import F, Q
from rest_framework import status
from rest_framework.generics import ListAPIView, CreateAPIView, DestroyAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from apps.tajweed.models.calendar import CalendarSlot
from apps.tajweed.models.exams import ExamReservation
from apps.tajweed.serializers import ExamReservationSerializer, CalendarSlotSerializer, ExamReservationUserSerializer


class ExamSlotsListAPIView(ListAPIView):
    serializer_class = CalendarSlotSerializer

    def get_queryset(self):
        return CalendarSlot.objects.filter(
            Q(available_slots__gt=F('reserved_slots')) &
            ~Q(examreservation__user=self.request.user)
        )

    def get(self, request, *args, **kwargs):
        queryset = self.filter_queryset(self.get_queryset())

        paginator = self.pagination_class()
        paginated_queryset = paginator.paginate_queryset(queryset, request)

        serializer = self.get_serializer(paginated_queryset, many=True)

        return paginator.get_paginated_response(serializer.data)


class ExamRequestAPIView(CreateAPIView):
    permission_classes = [IsAuthenticated, ]
    serializer_class = ExamReservationSerializer

    def post(self, request, *args, **kwargs):
        calendar_slot_id = kwargs['pk']

        try:
            calendar_slot = CalendarSlot.objects.get(id=calendar_slot_id)
        except ObjectDoesNotExist:
            error_message = "The specified CalendarSlot does not exist."
            return Response({'error': error_message}, status=status.HTTP_404_NOT_FOUND)

        serializer = self.get_serializer(data=request.data, context={'request': request, 'kwargs': kwargs})
        # serializer.is_valid(raise_exception=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class ExamReservationCancelAPIView(DestroyAPIView):
    permission_classes = [IsAuthenticated, ]

    def delete(self, request, *args, **kwargs):
        reservation_id = kwargs['pk']

        reservations = ExamReservation.objects.filter(id=reservation_id, user=request.user)

        if not reservations.exists():
            return Response({"message": "Reservation not found or you don't have permission to cancel it."},
                            status=status.HTTP_404_NOT_FOUND)

        reservation = reservations.first()
        calendar_slot = reservation.calendar_slot
        calendar_slot.reserved_slots = max(calendar_slot.reserved_slots - 1, 0)
        calendar_slot.save()
        reservation.delete()

        return Response({"message": "Reservation deleted successfully."})


class UserExamReservationListAPIView(ListAPIView):
    serializer_class = ExamReservationUserSerializer
    permission_classes = [IsAuthenticated, ]

    def get(self, request, *args, **kwargs):
        queryset = ExamReservation.objects.filter(user=self.request.user)

        queryset = self.filter_queryset(queryset)
        paginator = self.pagination_class()
        paginated_queryset = paginator.paginate_queryset(queryset, request)

        serializer = self.get_serializer(paginated_queryset, many=True)

        return paginator.get_paginated_response(serializer.data)
