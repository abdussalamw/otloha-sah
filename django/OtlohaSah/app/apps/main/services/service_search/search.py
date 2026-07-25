import importlib
from abc import ABC, abstractmethod
from django.conf import settings


class SearchAbstract(ABC):
    @abstractmethod
    def search(self, queryset, columns=None, value=''):
        if columns is None:
            columns = []

    @abstractmethod
    def ranked_search(self, queryset, columns, value):
        pass

    
class SearchProvider:
    def __init__(self):
        self.service = self.get_service_class()

    def search(self, queryset, columns, value):
        return self.service.search(queryset, columns, value)

    def ranked_search(self, queryset, search_index, value):
        return self.service.ranked_search(queryset, search_index, value)

    @staticmethod
    def get_service_class():
        service_name = settings.SEARCH_SERVICE_PROVIDER
        split_service_name = service_name.split('.')
        class_name = split_service_name[-1:][0]
        module_name = split_service_name[:-1]
        service_class = getattr(importlib.import_module('.'.join(module_name)), class_name)
        return service_class()
