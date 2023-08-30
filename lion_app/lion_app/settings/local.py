from .base import *

ALLOWED_HOSTS = [
    "localhost",
]

DEBUG = True

CSRF_TRUSTED_ORIGINS = [
    "http://localhost:8888",
    "http://localhost:8000",
]
