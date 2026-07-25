from django.utils.translation import gettext as _
from rest_framework import status
from rest_framework.decorators import action
from rest_framework.generics import get_object_or_404
from rest_framework.pagination import PageNumberPagination
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.viewsets import ViewSet

from .forms import PushNotificationTokenForm
from .models import Via
from .serializers import BaseNotificationSerializer


class Paginator(PageNumberPagination):
    page_size = 10


class NotificationsViewSet(ViewSet):
    permission_classes = [IsAuthenticated]
    serializer_class = BaseNotificationSerializer

    def get_queryset(self, request):
        return request.user.notification_receiver.all()

    def paginate(self, request, queryset):
        paginator = Paginator()
        paginated = paginator.paginate_queryset(queryset, request)
        serializer = self.serializer_class(paginated, many=True)
        return paginator.get_paginated_response(serializer.data)

    def list(self, request):
        queryset = self.get_queryset(request)
        if request.GET.get('mark_unseen') == 'true':
            queryset.filter(is_seen=False).update(is_seen=True)
        return self.paginate(request, queryset)

    @action(detail=True, methods=['get'])
    def mark_as_read(self, request, pk):
        notification = get_object_or_404(self.get_queryset(request), pk=pk)
        notification.mark_as_read()
        return Response({})

    @action(detail=False, methods=['post'])
    def mark_as_read(self, request):
        patch_id = request.POST.get('patch_id')
        if not patch_id:
            return Response(status=status.HTTP_422_UNPROCESSABLE_ENTITY)
        notification = get_object_or_404(self.get_queryset(request), user=request.user,
                                         patch_id=patch_id)
        notification.mark_as_read()
        return Response({})

    @action(detail=False, methods=['post'])
    def update_settings(self, request):
        user_via = request.user.notifications_via_settings.all()
        via_options = dict(Via.VIA_CHOICES)
        for slug, via in via_options.items():
            user_via_option = user_via.filter(slug=via)
            if not user_via_option.exists():
                is_active = request.POST.get(slug, True)
                Via.objects.create(
                    user=request.user,
                    slug=slug,
                    is_active=is_active,
                    name=via,
                )
            elif slug in request.POST:
                user_via_option.update(is_active=request.POST.get(slug))

        return Response({
            "message": _("Notification Settings Updated Successfully")
        })

    @action(detail=False, methods=['post'])
    def set_token(self, request, *args, **kwargs):
        form = PushNotificationTokenForm(data=request.data, user=request.user)
        if form.is_valid():
            form.save()
            return Response({})

        errors = {f: e.get_json_data()[0]['message'] for f, e in form.errors.items()}
        return Response(errors)
