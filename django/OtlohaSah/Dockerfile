FROM python:3.8-slim

LABEL maintainer="fritill.com"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY ./app /app
COPY ./scripts /scripts

WORKDIR /app

RUN apt-get update && \
    apt-get install -y postgresql-client gettext libmagic-dev && \
    python3 -m venv --system-site-packages /py && \
    /py/bin/pip3 install --upgrade pip && \
    /py/bin/pip3 install -r /requirements.txt

ENV PATH="/scripts:/py/bin:$PATH"

ARG UNAME=app
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o $UNAME

RUN adduser --uid $UID --gid $GID --disabled-password --system --no-create-home $UNAME && \
    mkdir -p /app/static && \
    mkdir -p /app/media && \
    mkdir -p /app/staticfiles && \
    chown -R app:app /app/static && \
    chmod -R 775 /app/static && \
    chown -R app:app /app/staticfiles && \
    chmod -R 775 /app/staticfiles && \
    chown -R app:app /app/media && \
    chmod -R 775 /app/media && \
    mkdir -p /app/uploads && \
    chown -R app:app /app/uploads && \
    chmod -R 775 /app/uploads && \
    chmod -R +x /scripts

USER app

EXPOSE 8000

CMD ["entrypoint.sh"]