#!/bin/sh

# 1. pull DB image
IMAGE_NAME="postgres"
IMAGE_TAG="13"
# 이미지를 가져옵니다.
docker pull ${IMAGE_NAME}:${IMAGE_TAG}

# 2. 환경파일은 만들어 놨음

# 3. run DB image
docker run -d -p 5432:5432 --name db \
    -v postgres_data:/var/lib/postgresql/data \
    --env-file .env \
    postgres:13
    #-e POSTGRES_DB=postgres \
    #-e POSTGRES_USER=postgres \
    #-e POSTGRES_PASSWORD="postgres!" \
    #-e POSTGRES_PORT=5432 \
    
    