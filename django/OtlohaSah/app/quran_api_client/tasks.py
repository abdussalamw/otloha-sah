from app.celery import app
from quran_api_client.client import QuranAPIClient


@app.task
def load_quran():
    """
    Loads the quran from the API.
    """
    print('Loading quran...')
    client = QuranAPIClient()
    client.authenticate()
    client.load_initial_data()
