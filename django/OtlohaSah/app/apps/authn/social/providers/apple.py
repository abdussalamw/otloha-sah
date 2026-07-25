from .base import BaseProvider


class AppleProvider(BaseProvider):
    def authorize(self, token):
        pass

    def get_user(self, data):
        pass

    def get_user_data(self, data):
        pass
