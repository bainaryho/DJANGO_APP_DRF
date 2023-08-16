import os

from .base import *

SECRET_KEY = os.getenv("DJANGO_SECRET_KEY")

DEBUG = True

ALLOWED_HOSTS = [
    "lion-lb-staging-18975819-5c1681faab26.kr.lb.naverncp.com",
]

#CSRF_TRUSTED_ORIGINS = [
#   "http://lion-lb-staging-18975819-5c1681faab26.kr.lb.naverncp.com",
#]