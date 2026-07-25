from django.contrib.auth.mixins import LoginRequiredMixin
from django.views import View

# from apps.assessments.models import UserCollection
# from apps.blog.models import Blog
# from apps.courses.models import Course, CourseUserProgress
# from apps.threads.models import Thread


class UserDashboardView(LoginRequiredMixin, View):
    pass
    # def get(self, request, *args, **kwargs):
    #     user = get_user(request)
    #     recommended_courses = []
    #     course_user_progress = CourseUserProgress.objects.filter(user=user)
    #     for item in course_user_progress:
    #         recommended_courses.append(item.course.get_related_courses)
    #
    #     return render(request, 'users/site/dashboard.html', {
    #         'courses_progress': CourseUserProgress.objects.filter(user=user),
    #         'user_collections': UserCollection.objects.filter(user=user),
    #         'blogs': Blog.objects.filter(author=user),
    #         'threads': Thread.objects.filter(author=user),
    #         'recommended_courses': recommended_courses,
    #         'recommended_blogs': [blog.get_related_blogs for blog in Blog.objects.filter(author=user)],
    #         'recommended_threads': [thread.get_related_threads for thread in Thread.objects.filter(author=user)],
    #     })
