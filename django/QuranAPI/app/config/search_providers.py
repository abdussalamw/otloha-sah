import os

SEARCH_SERVICE_PROVIDER = os.environ.get(
    'SEARCH_SERVICE_PROVIDER',
    'apps.main.services.service_search.providers.SQLSearchProvider',
)
