```
LION_DJANGO_APP
├─ .actrc
├─ .dockerignore
├─ .github
│  └─ workflows
│     ├─ CD.yml
│     ├─ CI.yml
│     ├─ lesson1.yml
│     ├─ lesson2.yml
│     ├─ lesson4.yml
│     ├─ lesson4_caller.yml
│     ├─ lesson5.yml
│     ├─ lesson5_up.yml
│     ├─ lesson5_use.yml
│     └─ output_handling.yml
├─ .gitignore
├─ .vscode
│  └─ settings.json
├─ docker-compose.prod.yml
├─ docker-compose.yml
├─ Dockerfile.nginx_ubt
├─ event.json
├─ lion_app
│  ├─ blog
│  │  ├─ admin.py
│  │  ├─ apps.py
│  │  ├─ migrations
│  │  │  └─ __init__.py
│  │  ├─ models.py
│  │  ├─ serializers.py
│  │  ├─ tests.py
│  │  ├─ urls.py
│  │  ├─ views.py
│  │  └─ __init__.py
│  ├─ common
│  │  ├─ aws.py
│  │  └─ __init__.py
│  ├─ Dockerfile
│  ├─ Forum
│  │  ├─ admin.py
│  │  ├─ apps.py
│  │  ├─ migrations
│  │  │  ├─ 0001_initial.py
│  │  │  └─ __init__.py
│  │  ├─ models.py
│  │  ├─ serializers.py
│  │  ├─ tests.py
│  │  ├─ urls.py
│  │  ├─ views.py
│  │  └─ __init__.py
│  ├─ lion_app
│  │  ├─ asgi.py
│  │  ├─ django.nginx
│  │  ├─ gunicorn_config.py
│  │  ├─ settings
│  │  │  ├─ base.py
│  │  │  ├─ local.py
│  │  │  ├─ prod.py
│  │  │  ├─ staging.py
│  │  │  └─ __init__.py
│  │  ├─ urls.py
│  │  ├─ wsgi.py
│  │  └─ __init__.py
│  ├─ manage.py
│  ├─ requirements.txt
│  └─ scripts
│     ├─ entrypoint
│     └─ start
├─ README.md
└─ scripts
   ├─ deploy.sh
   ├─ nginx_entry
   ├─ runserver.sh
   ├─ run_gunicorn.sh
   ├─ set_server.sh
   └─ set_user.sh

```