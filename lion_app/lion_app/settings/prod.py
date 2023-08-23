import os

from .base import *

SECRET_KEY = os.getenv("DJANGO_SECRET_KEY")

DEBUG = True

ALLOWED_HOSTS = [
    "lion-lb-18904310-af56000f5c59.kr.lb.naverncp.com",
    "be-prod-lb-staging-19158776-abf59d103840.kr.lb.naverncp.com",
]

CSRF_TRUSTED_ORIGINS = [
    "http://lion-lb-18904310-af56000f5c59.kr.lb.naverncp.com",
    "http://be-prod-lb-staging-19158776-abf59d103840.kr.lb.naverncp.com",
]
