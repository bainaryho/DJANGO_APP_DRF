# Gunicorn은 WSGI 서버로서 Django 애플리케이션을 실행하는 역할
# 이 설정 파일은 Gunicorn이 동작하는 방식을 지정
import multiprocessing

# Gunicorn이 바인딩할 주소와 포트를 지정합니다.
# "0.0.0.0:8000"은 모든 IP 주소에서 8000번 포트로 들어오는 요청을 처리하도록 설정
bind = "0.0.0.0:8000"
# Gunicorn이 실행할 워커 프로세스의 수를 지정합니다. 이 설정은 동시에 처리할 수 있는 요청의 수를 결정하며, 보통 CPU 코어 수의 2배에 1을 더한 값을 사용합니다
workers = multiprocessing.cpu_count() * 2 + 1
