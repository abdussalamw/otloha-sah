import os
from urllib.parse import quote

REDIS_HOST = os.environ.get('REDIS_HOST', 'localhost')
REDIS_PORT = os.environ.get('REDIS_PORT', '6379')
REDIS_PASSWORD = os.environ.get('REDIS_PASSWORD', '')

if REDIS_PASSWORD:
    _credentials = f':{quote(REDIS_PASSWORD, safe="")}@'
else:
    _credentials = ''

REDIS_URL = os.environ.get(
    'REDIS_URL',
    f'redis://{_credentials}{REDIS_HOST}:{REDIS_PORT}/0',
)
REDIS_CACHE_URL = os.environ.get(
    'REDIS_CACHE_URL',
    f'{REDIS_URL.rsplit("/", 1)[0]}/1',
)
