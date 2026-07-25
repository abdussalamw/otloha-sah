from time import perf_counter

from django.db import connection

from apps.loggers.models import SignalLog, APILog


def log_signal(signal_name, time_taken):
    SignalLog.objects.create(signal_name=signal_name, time_taken=time_taken)


def signal_decorator(func):
    def wrapper(*args, **kwargs):
        signal_name = func.__name__
        start_counter = perf_counter()
        result = func(*args, **kwargs)
        end_count = perf_counter()
        time_taken = end_count - start_counter
        log_signal(signal_name, time_taken)
        return result

    return wrapper


def log_api_request(view_name, time_taken, url_path, method, code):
    queries = "\n".join([str(item['sql'])for item in connection.queries])
    return APILog.objects.create(view_name=view_name, time_taken=time_taken, url_path=url_path, method=method,
                                 code=code,queries=queries, db_hits=len(connection.queries))


class APILoggingMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        start_time = perf_counter()

        response = self.get_response(request)

        end_time = perf_counter()
        duration = end_time - start_time
        view_name = self.get_view_name(request)
        url_path = self.preprocess_url_path(request.path)
        method = request.method
        code = response.status_code

        api_log = log_api_request(view_name, duration, url_path, method, code)
        api_log.clean()

        return response

    def get_view_name(self, request):
        view_name = getattr(request.resolver_match, 'view_name', 'Unknown View')
        return view_name

    @staticmethod
    def preprocess_url_path(url_path):
        url_slices = url_path.split("/")
        url_slices = [part if not part.isdigit() else '__id__' for part in url_slices]
        return '/'.join(url_slices)
