from django import template
from django.template.loader import get_template

register = template.Library()


@register.filter
def get_room_peers(room, user):
    return room.peers(user)


@register.inclusion_tag(get_template('chat/partials/rooms/_list.html'))
def chat_room_list(user, room_type):
    return {
        'user': user,
        'rooms': user.rooms.filter(room_type=room_type)
    }
