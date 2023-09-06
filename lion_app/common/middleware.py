from django.http import HttpResponseNotFound


class HealthcheckMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # "healthcheck" 경로로 오는 요청을 허용
        if request.path == "/health/":
            return self.get_response(request)
        # 다른 모든 요청에 대해서는 404 응답 반환
        else:
            return HttpResponseNotFound("Not Found")
