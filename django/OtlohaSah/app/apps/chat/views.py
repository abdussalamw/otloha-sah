from django.contrib.auth.mixins import LoginRequiredMixin
from django.http import Http404
from django.shortcuts import render, get_object_or_404
from django.views import View

from apps.chat.models import Room


class RoomsListView(LoginRequiredMixin, View):
    def get(self, request, room_type, *args, **kwargs):
        if room_type not in list(dict(Room.ROOM_TYPES).keys()):
            raise Http404

        context = {'room_type': room_type, }

        if kwargs.get('pk', None):
            context.update({"room": get_object_or_404(request.user.rooms.all(), pk=kwargs['pk'])})

        return render(request, 'chat/rooms.html', context)
