from django.http import JsonResponse, HttpResponseServerError
from django.conf import settings

request_count = 0


def healthcheck(request):
    # 간단한 응답을 반환합니다.
    response_data = {"status": "Health Check OK"}
    return JsonResponse(response_data)


def get_version(request):
    global request_count
    response_data = {"version": settings.VERSION}
    return JsonResponse(response_data)
