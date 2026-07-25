from django.contrib.auth.mixins import LoginRequiredMixin
from django.http import JsonResponse
from django.views import View

from apps.users.filters import get_user_filterset_class
from apps.users.views.mixins import UserTypeValidationMixin


class UserStatisticsView(UserTypeValidationMixin, LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        print('=' * 100)
        queryset = self.model.objects.all()
        print(request.GET)
        filterset = get_user_filterset_class(self.user_type)(data=request.GET, queryset=queryset.all()).qs

        return JsonResponse({
            "value": filterset.count()
        })
