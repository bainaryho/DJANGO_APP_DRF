import os

from .base import *

SECRET_KEY = os.getenv("DJANGO_SECRET_KEY")

DEBUG = True

ALLOWED_HOSTS = [
    "be-lb-staging-19182292-2e28562dcf22.kr.lb.naverncp.com",
]

CSRF_TRUSTED_ORIGINS = [
    "http://be-lb-staging-19182292-2e28562dcf22.kr.lb.naverncp.com",
]
