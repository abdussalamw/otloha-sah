from django.urls import path, include

app_name = 'admin'

urlpatterns = [

    path('', include('apps.main.urls_admin', namespace='main')),
    path('users/', include('apps.users.urls.admin.user_urls', namespace='users')),
    path('groups/', include('apps.users.urls.admin.group_urls', namespace='groups')),
    path('books/', include('apps.quran.urls_admin', namespace='books')),
    path('narrations/', include('apps.narrations.urls_admin', namespace='narrations')),
    path('parts/', include('apps.parts.urls_admin', namespace="parts")),
    path('recitations/', include('apps.recitations.urls_admin', namespace='recitations')),
    path('chapters/', include('apps.chapters.urls_admin', namespace='chapters')),
    path('files/', include('apps.files_handler.urls', namespace='files')),
    path('tajweed/', include('apps.tajweed.urls_admin', namespace='tajweed')),
    path('translations/', include('apps.translations.urls_admin', namespace='translations')),
    path('explanations/', include('apps.explanations.urls_admin', namespace='explanations')),

    path('', include('translation.urls', namespace='translation')),
    path('delete/', include('softdelete.urls', namespace='softdelete')),
]
