from app.config.main import *

# Database
# https://docs.djangoproject.com/en/3.2/ref/settings/#databases

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "project_name.settings.local")

DATABASES = {
    # 'default': {
    #     'ENGINE': 'django.db.backends.sqlite3',
    #     'NAME': 'mydatabase',
    # }
    'default': {
        'ENGINE': os.environ.get("DATABASE_ENGINE", "django.db.backends.sqlite3"),
        'NAME': os.environ.get('DATABASE_NAME', BASE_DIR / "db.sqlite3"),
        'USER': os.environ.get('DATABASE_USER', 'default'),
        'PASSWORD': os.environ.get('DATABASE_PASS', 'default'),
        "HOST": os.environ.get("DATABASE_HOST", "localhost"),
        "PORT": os.environ.get("DATABASE_PORT", "5432"),
    }
}

FIXTURE_DIRS = (BASE_DIR / "fixtures",)
