import logging
import traceback
from collections import OrderedDict

from rest_framework import exceptions
from rest_framework.pagination import PageNumberPagination as BasePageNumberPagination
from rest_framework.response import Response
from rest_framework.views import exception_handler

logger = logging.getLogger(__name__)


def custom_exception_handler(exc, context):
    response = exception_handler(exc, context)
    if not response:
        request_info = {
            'method': context['request'].method,
            'path': context['request'].path,
            'data': context['request'].data,
        }

        # Get the traceback information as an array
        trace_info = traceback.format_exception(type(exc), exc, exc.__traceback__)
        print('Traceback information:\n', ''.join(trace_info))

        # Customize details for the APIException
        details = {
            'error': 'An error occurred',
            'custom_details': 'Additional details for the generic APIException',
            'request_info': request_info,
            'trace_info': trace_info,
        }
        exc = exceptions.APIException(detail=details)
        response = exception_handler(exc, context)
    return response


class PageNumberPagination(BasePageNumberPagination):
    page_size_query_param = 'page_size'

    def get_paginated_response(self, data):
        return Response(OrderedDict([
            ('count', self.page.paginator.count),
            ('next', self.get_next_link()),
            ('previous', self.get_previous_link()),
            ("page", self.page.number),
            ("page_size", self.page_size),
            ('results', data)
        ]))
