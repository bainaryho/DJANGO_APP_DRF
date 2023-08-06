LION_DJANGO_APP
├─ .gitignore
├─ docker-compose.yml#Django 프로젝트와 관련된 Docker 서비스들을 정의하여 한 번에 여러 컨테이너를 실행/관리할 수 있도록 도와줍니다.
├─ Dockerfile.nginx_ubt #엔진엑스 빌드 도커파일
├─ lion_app
│  ├─ Dockerfile #장고 빌드 도커파일
│  ├─ Forum
│  ├─ lion_app
│  │  ├─ asgi.py 
│  │  ├─ django.nginx #nginx 서버 블록 설정 파일
│  │  ├─ gunicorn_config.py #start scripts에서 실행됨
│  │  ├─ settings.py
│  │  ├─ urls.py
│  │  ├─ wsgi.py
│  │  └─ __init__.py
│  ├─ manage.py
│  ├─ requirements.txt
│  └─ scripts#Django 프로젝트를 Docker컨테이너로 배포하기 위한 스크립트
│     └─ start
├─ README.md
└─ scripts#Django 프로젝트 배포와 관련된 스크립트들이 위치하는 디렉토리입니다.
   ├─ deploy.sh
   ├─ runserver.sh
   ├─ run_gunicorn.sh
   ├─ set_server.sh
   └─ set_user.sh
