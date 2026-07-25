import logging
import sys
import traceback
import uuid
import asyncio

from django.conf import settings
from django.contrib.postgres.aggregates import ArrayAgg
from django.core.mail import send_mail
from django.utils.translation import activate, deactivate
from firebase_admin import messaging

from app.celery import app

logger = logging.getLogger(__name__)


def get_trace():
    parts = ["Traceback (most recent call last):\n"]
    parts.extend(traceback.format_stack(limit=25)[:-2])
    parts.extend(traceback.format_exception(*sys.exc_info())[1:])
    return "".join(parts)


def get_apns_config(msg, collapse_key):
    options = {}
    image = msg.pop("image", None)
    if image:
        options['image'] = image

    return messaging.APNSConfig(
        payload=messaging.APNSPayload(
            aps=messaging.Aps(
                alert=messaging.ApsAlert(**msg),
                badge=1,
                sound='default',
                mutable_content=True
            ),
        ),
        fcm_options=messaging.APNSFCMOptions(**options),
        headers={'apns-collapse-id': collapse_key}
    )


def get_android_config(notification, icon, collapse_key):
    return messaging.AndroidConfig(
        collapse_key=collapse_key,
        notification=messaging.AndroidNotification(
            **notification,
            icon=icon,
            color='#3682d8',
        )
    )


def send_batch(message):
    try:
        response = messaging.send_each_for_multicast(message)
        logger.info(f"Successfully sent batch message with response: {response.__dict__}")
    except Exception as e:
        logger.error(f"Error sending multicast message: {e}")
        logger.error(e, exc_info=True)


async def patching_messages(tokens, notification, icon, collapse_key, pn_data):
    # Batch processing
    batch_size = 500
    token_batches = [tokens[i:i + batch_size] for i in range(0, len(tokens), batch_size)]

    loop = asyncio.get_event_loop()
    tasks = []
    for tokens in token_batches:
        message = messaging.MulticastMessage(
            notification=messaging.Notification(**notification),
            android=get_android_config(notification, icon, collapse_key),
            apns=get_apns_config(notification, collapse_key),
            data=pn_data,
            tokens=tokens
        )
        task = loop.run_in_executor(None, send_batch, message)
        tasks.append(task)

    # Await all tasks to handle exceptions and ensure completion
    await asyncio.gather(*tasks)


@app.task
def send_pn_multicast_message(language, tokens_list, notification, pn_data, collapse_key):
    collapse_key = str(collapse_key)
    activate(language)
    tokens = [token for tokens in tokens_list for token in tokens]
    icon = notification.pop('icon', None)  # Use pop with default value to prevent KeyError
    asyncio.run(patching_messages(tokens, notification, icon, collapse_key, pn_data))
    deactivate()


@app.task
def send_pn_message(language, tokens_list, notification, collapse_key, pn_data, topic=None):
    activate(language)
    icon = notification.pop('icon')

    data = {
        "notification": messaging.Notification(**notification),
        "android": get_android_config(notification, icon, collapse_key),
        "apns": get_apns_config(notification, collapse_key),
        "data": pn_data,
        "tokens": tokens_list
    }
    if topic:
        data['topic'] = topic

    message = messaging.MulticastMessage(**data)

    try:
        response = messaging.send(message)
    except Exception as e:
        logger.error(f"Error sending multicast message: {e}")
    finally:
        deactivate()


@app.task
def send_email(language, receivers, email_data):
    activate(language)

    subject = email_data.get('subject')
    message = email_data.get('message')
    from_email = email_data.get('from_email') if email_data.get('from_email', None) else settings.DEFAULT_FROM_EMAIL

    try:
        send_mail(subject, message, from_email, receivers)
    except Exception as e:
        logger.error(f"Error sending email: {e}")
    finally:
        deactivate()


@app.task
def send_database_notification(
        language,
        receivers,
        notification,
        to_push_notification=False,
        pn_notification=None,
        pn_data=None,
        collapse_key=None):
    activate(language)

    from django.contrib.auth import get_user_model
    from apps.notifications.models import Notification
    receivers = get_user_model().objects.filter(id__in=receivers).annotate(
        tokens=ArrayAgg('push_notification_tokens__token', distinct=True)
    ).values_list('id', 'tokens')

    patch_id = uuid.uuid4()
    tokens = []
    notification_objs = []
    for user_id, tokens in receivers:
        notification_obj = Notification(
            **notification,
            user_id=user_id,
            patch_id=patch_id,
        )

        if to_push_notification:
            receiver_tokens = list(set(tokens))
            any(receiver_tokens) and tokens.append(receiver_tokens)

        notification_objs.append(notification_obj)

    Notification.objects.bulk_create(notification_objs)
    if len(tokens):
        send_pn_multicast_message.delay(
            language=language,
            tokens_list=tokens,
            notification=pn_notification,
            pn_data={**pn_data, "patch_id": str(patch_id)},
            collapse_key=collapse_key
        )
