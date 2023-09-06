from django.http import JsonResponse


def healthcheck(request):
    # 간단한 응답을 반환합니다.
    response_data = {"status": "Health Check OK"}
    return JsonResponse(response_data)
