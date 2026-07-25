from app.config.main import *

SEARCH_SERVICE = os.environ.get("SEARCH_SERVICE",
                                "apps.apps.main.services.search_services.sqlite_search_service.SQLiteSearchService")
