INSTALLED_APPS = [
    # 'channels',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'django_extensions',
    'django.contrib.sites',
    'django.contrib.humanize',

    # apps
    'apps.quran',
    'apps.main',
    'apps.users',
    'apps.files_handler',
    'apps.tajweed',
    'apps.narrations',
    'apps.chapters',
    'apps.parts',
    'apps.translations',
    'apps.recitations',
    
    # external packages
    'apps.explanations',
    'rest_framework',
    'rest_framework.authtoken',
    'translation',
    'oauth2_provider',
    'softdelete',

    'django_filters',
    'import_export',
    "corsheaders",
    # 'crispy_forms',

    'drf_yasg',
    'debug_toolbar',
    'django_rest_passwordreset',
    'dynamic_listing',
    'base_template',
    'django_celery_beat',
    'django_celery_results'
]
