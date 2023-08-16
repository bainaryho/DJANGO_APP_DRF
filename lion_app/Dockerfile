# 베이스 이미지로 Python 3.11 Alpine 이미지를 사용
FROM python:3.11-alpine

# 앱의 홈 디렉토리를 지정
ARG APP_HOME=/app

# 환경 변수를 설정
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

# 앱의 홈 디렉토리를 생성
RUN mkdir ${APP_HOME}

# 호스트의 requirements.txt를 컨테이너의 현재 디렉토리로 복사
COPY ./requirements.txt ./

# 필요한 라이브러리를 설치
RUN pip install --no-cache-dir -r requirements.txt

# 현재 디렉토리의 파일들을 컨테이너의 앱 홈 디렉토리로 복사
COPY . ${APP_HOME}

# 스크립트를 컨테이너에 복사하고 실행 가능한 권한 부여
COPY ./scripts/start /start
RUN sed -i 's/\r$//g' /start
RUN chmod +x /start

COPY ./scripts/entrypoint /entrypoint
RUN sed -i 's/\r$//g' /entrypoint
RUN chmod +x /entrypoint

# 작업 디렉토리를 앱의 홈 디렉토리로 설정
WORKDIR ${APP_HOME}

# 컨테이너가 실행될 때 수행할 기본 명령을 설정
ENTRYPOINT [ "/entrypoint" ]
CMD [ "/start" ]
