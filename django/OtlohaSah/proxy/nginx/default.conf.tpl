upstream django_app {
    server app:8000;
}

server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};

    error_log  /var/log/nginx/error.log;
    access_log  /var/log/nginx/access.log;

    location /.well-known/acme-challenge/ {
        root /vol/www/;
    }

    location /static/ {
        alias /app/staticfiles/;
        add_header Access-Control-Allow-Origin *;
    }

    location /media/ {
        alias /app/media/;
        add_header Access-Control-Allow-Origin *;
    }

    include /etc/nginx/asgi_params;

    location / {
        proxy_pass http://django_app;
        include /etc/nginx/wsgi_params;
        client_max_body_size 10M;
    }
}
