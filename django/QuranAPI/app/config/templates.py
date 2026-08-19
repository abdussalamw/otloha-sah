from app.config.main import *
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [
            BASE_DIR / 'templates'
        ],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'apps.main.context_processors.admin_sidebar.admin_sidebar',
                'apps.main.context_processors.user_sidebar.user_sidebar',
            ],
        },
    },
]

FORM_RENDERER = "django.forms.renderers.DjangoTemplates"
