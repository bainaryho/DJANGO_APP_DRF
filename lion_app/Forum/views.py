from rest_framework.decorators import action
from django.shortcuts import get_object_or_404
from drf_spectacular.utils import extend_schema
from rest_framework import viewsets, status
from rest_framework.request import Request
from rest_framework.response import Response

from .models import Topic, Post, TopicGroupUser
from .serializers import TopicSerializer, PostSerializer


@extend_schema(tags=["Topic"])
class TopicViewSet(viewsets.ModelViewSet):
    queryset = Topic.objects.all()
    serializer_class = TopicSerializer

    @extend_schema(summary="새 토픽 생성")
    def create(self, request, *args, **kwargs):
        return super().create(request, *args, **kwargs)

    @action(detail=True, methods=["get"], url_name="posts")
    def posts(self, request: Request, *args, **kwargs):
        topic: Topic = self.get_object()
        user = request.user
        # 유저가 권한이 있는지 확인.

        if not topic.can_be_access_by(user):
            return Response(
                status=status.HTTP_401_UNAUTHORIZED,
                data="This user is not allowed to Read this topic",
            )

        posts = topic.posts
        serializer = PostSerializer(posts, many=True)
        return Response(data=serializer.data)


@extend_schema(tags=["Post"])
class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer

    @extend_schema(deprecated=True)
    def list(self, request, *args, **kwargs):
        return Response(status=status.HTTP_400_BAD_REQUEST, data="Deprecated API")

    def create(self, request: Request, *args, **kwargs):
        user = request.user
        data = request.data
        topic_id = data.get("topic")
        topic = get_object_or_404(Topic, id=topic_id)

        if not topic.can_be_access_by(user):
            return Response(
                status=status.HTTP_401_UNAUTHORIZED,
                data="This user is not allowed to write this topic",
            )

        # 부모의 create부분 전부 오버라이드
        serializer = PostSerializer(data=request.data)
        if serializer.is_valid():
            data = serializer.validated_data
            data["owner"] = user
            res: Post = serializer.create(data)
            return Response(
                status=status.HTTP_201_CREATED, data=PostSerializer(res).data
            )
        else:
            return Response(status=status.HTTP_400_BAD_REQUEST, data=serializer.errors)

    def retrieve(self, request, *args, **kwargs):
        post: Post = self.get_object()
        user = request.user
        # 포스트에 토픽에 대한 권한이 있나 확인
        topic = post.topic

        if not topic.can_be_access_by(user):
            return Response(
                status=status.HTTP_401_UNAUTHORIZED,
                data="이 유저는 이 포스트를 읽지 못합니다",
            )

        return super().retrieve(request, *args, **kwargs)
