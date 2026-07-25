__all__ = (
    "FacebookProvider",
    "GSIProvider",
    "XOAUTH2Provider",
    'SOCIAL_AUTH_PROVIDERS',
    'SOCIAL_AUTH_PROVIDERS_TUPLE',
    'get_provider'
)

from .apple import AppleProvider
from .facebook import FacebookProvider
from .google import GSIProvider
from .x_oauth_2 import XOAUTH2Provider

SOCIAL_AUTH_PROVIDERS = {
    "gsi": GSIProvider,
    "x": XOAUTH2Provider,
    "facebook": FacebookProvider,
    "apple": AppleProvider
}

SOCIAL_AUTH_PROVIDERS_TUPLE = ((key, value) for key, value in SOCIAL_AUTH_PROVIDERS.items())


def get_provider(provider):
    return SOCIAL_AUTH_PROVIDERS.get(provider)
