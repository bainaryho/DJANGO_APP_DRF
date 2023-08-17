from django.shortcuts import get_object_or_404
from rest_framework.response import Response
from rest_framework import viewsets, status
from drf_spectacular.utils import extend_schema

from .models import Topic, Post, TopicGroupUser
from .serializers import TopicSerializer, PostSerializer


@extend_schema(tags=["Topic"])
class TopicViewSet(viewsets.ModelViewSet):
    queryset = Topic.objects.all()
    serializer_class = TopicSerializer

    @extend_schema(summary="새 토픽 생성")
    def create(self, requset, *args, **kwargs):
        return super().create(requset, *args, **kwargs)


@extend_schema(tags=["Post"])
class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    def create(self, request, *args, **kwargs):
        # 권한 그룹 체크 후 글을 작성합니다
        # 유저가 권한을 가지고 있으면 글을 작성하게 해줌
        user = request.user
        data = request.data
        topic_id = data.get("topic")
        topic = get_object_or_404(Topic, id=topic_id)
        if topic.is_private:
            qs = TopicGroupUser.objects.filter(
                group__lte=TopicGroupUser.GroupChoices.common,
                topic=topic,
                user=user,
            )
            if not qs.exists():
                return Response(
                    status=status.HTTP_401_UNAUTHORIZED, data="유저는 해당 토픽에 글을 쓸 권한이 없습니다"
                )

        return super().create(request, *args, **kwargs)
