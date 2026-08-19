import os


def env_bool(value):
    normalized = str(value).strip().lower()
    if normalized in {'y', 'yes', 't', 'true', 'on', '1'}:
        return True
    if normalized in {'n', 'no', 'f', 'false', 'off', '0'}:
        return False
    raise ValueError(f'Invalid boolean environment value: {value!r}')


CORS_ALLOWED_ORIGINS = [
    origin.strip()
    for origin in os.environ.get('CORS_ALLOWED_ORIGINS', '').split(',')
    if origin.strip()
]
CORS_ALLOW_CREDENTIALS = env_bool(
    os.environ.get('CORS_ALLOW_CREDENTIALS', 'false')
)
