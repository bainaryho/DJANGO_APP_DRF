
```
LION_DJANGO_APP
├─ .gitignore
├─ docker-compose.yml
├─ Dockerfile.nginx_ubt
├─ lion_app
│  ├─ Dockerfile
│  ├─ Forum
│  │  ├─ admin.py
│  │  ├─ apps.py
│  │  ├─ migrations
│  │  │  ├─ 0001_initial.py
│  │  │  └─ __init__.py
│  │  ├─ models.py
│  │  ├─ tests.py
│  │  ├─ views.py
│  │  └─ __init__.py
│  ├─ lion_app
│  │  ├─ asgi.py
│  │  ├─ django.nginx
│  │  ├─ gunicorn_config.py
│  │  ├─ settings.py
│  │  ├─ urls.py
│  │  ├─ wsgi.py
│  │  └─ __init__.py
│  ├─ manage.py
│  ├─ requirements.txt
│  └─ scripts
│     └─ start
├─ README.md
└─ scripts
   ├─ deploy.sh
   ├─ runserver.sh
   ├─ run_gunicorn.sh
   ├─ set_server.sh
   └─ set_user.sh

```