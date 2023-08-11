from rest_framework import viewsets
from drf_spectacular.utils import extend_schema

from .models import Topic, Post
from .serializers import TopicSerializer, PostSerializer


@extend_schema(tags=["Topic", "Forum"])
class TopicViewSet(viewsets.ModelViewSet):
    queryset = Topic.objects.all()
    serializer_class = TopicSerializer


@extend_schema(tags=["Post", "Forum"])
class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer