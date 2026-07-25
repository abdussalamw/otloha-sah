from django.utils.deprecation import MiddlewareMixin
from django.utils.translation import activate


class LocaleMiddleware(MiddlewareMixin):
    # def process_view(self, request, view_func, view_args, view_kwargs):
    #     if view_func is set_language:
    #         user = request.user
    #         if user.is_authenticated:
    #             user.locale = request.POST.get('language')
    #             user.save()
    #     return None

    def __init__(self, get_response):
        super().__init__(get_response)
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)

        if request.user.is_authenticated:
            if hasattr(request, 'resolver_match') and hasattr(request.resolver_match, 'view_name') \
                    and request.resolver_match.view_name == 'set_language':
                user = request.user
                language_code = request.POST.get('language')
                if language_code:
                    user.locale = language_code
                    user.save()
                    activate(language_code)
            else:
                user_language = request.META.get('HTTP_ACCEPT_LANGUAGE')
                if user_language:
                    user = request.user
                    user.locale = user_language
                    user.save()
                    activate(user_language)

        return response
