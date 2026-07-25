import base64
import os

import requests

from .models import Narration, Chapter, Verse, Part


class QuranAPIClient:
    """
from quran_api_client.tasks import load_quran
load_quran()
    """
    CREDENTIALS = None
    TOKEN = None
    EXPIRE_TIME = None
    TOKEN_TYPE = None
    SCOPE = None

    def __init__(self):
        self.base_url = os.environ.get('QURAN_API_CLIENT_URL', None)
        self.client_id = os.environ.get('QURAN_API_CLIENT_ID', None)
        self.client_secret = os.environ.get('QURAN_API_CLIENT_SECRET', None)

    def load_initial_data(self):
        if not self.CREDENTIALS:
            self.get_credentials()

        if not self.TOKEN:
            self.authenticate()

        self.get_narrations()
        self.get_chapters()
        for narration in Narration.objects.all():
            self.get_verses(narration.id)

    def get_credentials(self):
        credentials = "{0}:{1}".format(self.client_id, self.client_secret)
        self.CREDENTIALS = base64.b64encode(credentials.encode("utf-8"))

    def authenticate(self):
        if not self.CREDENTIALS:
            self.get_credentials()

        url = self.base_url + 'o/token/'
        response = requests.request("POST", url, headers={
            'Authorization': 'Basic ' + str(self.CREDENTIALS.decode("ascii")),
            'Content-Type': 'application/x-www-form-urlencoded',
            'Cache-Control': 'no-cache',
        }, data='grant_type=client_credentials')
        data = response.json()
        self.TOKEN = data['access_token']
        self.EXPIRE_TIME = data['expires_in']
        self.TOKEN_TYPE = data['token_type']
        self.SCOPE = data['scope']

    def send_request(self, method, url, data=None):
        response = requests.request(method, url, headers={
            'Authorization': "{} {}".format(self.TOKEN_TYPE, self.TOKEN),
            'Content-Type': 'application/json',
            'Cache-Control': 'no-cache',
        }, data=data)
        return response.json()

    def get_narrations(self):
        url = '{}api/v1/narrations/'.format(self.base_url)
        response = self.send_request('GET', url)
        for narration in response:
            Narration.objects.update_or_create(id=narration['id'], defaults={
                'id': narration['id'],
                'name': narration['name'],
                'description': narration['description']
            })

    def get_narration(self, narration_id):
        url = '{}api/v1/narrations/{}/'.format(self.base_url, narration_id)
        response = self.send_request('GET', url)
        Narration.objects.update_or_create(id=narration_id, defaults={
            'id': response['id'],
            'name': response['name'],
            'description': response['description']
        })


    def get_parts(self):
        url = '{}api/v1/parts/'.format(self.base_url)
        response = self.send_request('GET', url)
        for part in response:
            Part.objects.update_or_create(id=part['id'], defaults={
                'id': part['id'],
                'name': part['name'],
                'alias': part['alias'],
                'part_number': part['part_number'],
                'is_active': part['is_active']
            })

    def part(self, part_id):
        url = '{}api/v1/parts/{}/'.format(self.base_url, part_id)
        response = self.send_request('GET', url)
        Part.objects.update_or_create(id=part_id, defaults={
            'id': response['id'],
            'name': response['name'],
            'alias': response['alias'],
            'part_number': response['part_number'],
            'is_active': response['is_active']
        })


    def get_chapters(self):
        url = '{}api/v1/chapters/'.format(self.base_url)
        response = self.send_request('GET', url)
        for chapter in response:
            Chapter.objects.update_or_create(id=chapter['id'], defaults={
                'id': chapter['id'],
                'name': chapter['name'],
                'origin': chapter['origin'],
                'chapter_number': chapter['chapter_number'],
            })

    def get_chapter(self, chapter_id):
        url = '{}api/v1/chapters/{}/'.format(self.base_url, chapter_id)
        response = self.send_request('GET', url)
        Chapter.objects.update_or_create(id=chapter_id, defaults={
            'id': response['id'],
            'name': response['name'],
            'origin': response['origin'],
            'chapter_number': response['chapter_number'],
        })

    def get_verses(self, narration_id):
        url = '{}api/v1/narrations/{}/verses/'.format(self.base_url, narration_id)
        response = self.send_request('GET', url)
        for verse in response:
            Verse.objects.update_or_create(id=verse['id'], defaults={
                'id': verse['id'],
                'text': verse['text'],
                'line_start': verse['line_start'],
                'line_end': verse['line_end'],
                'verse_number': verse['verse_number'],
                'page_number': verse['page_number'],
                'chapter_number': verse['chapter_number'],
                'part_number': verse['part_number'],
                'chapter_id': verse['chapter'],
                'narration_id': verse['narration'],
            })


