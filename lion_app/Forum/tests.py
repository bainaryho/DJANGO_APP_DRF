import json

from django.contrib.auth.models import User
from django.urls import reverse
from rest_framework.test import APITestCase
from django.http import HttpResponse
from rest_framework import status

from .models import Topic, Post, TopicGroupUser


class PostTest(APITestCase):
    # 셋업
    # 토픽 - 프라이빗
    # user1 - 권한없음
    # user2 - 권한있음
    @classmethod
    def setUpTestData(cls):
        cls.superuser = User.objects.create_superuser("superuser")
        cls.private_topic = Topic.objects.create(
            name="private Topic",
            is_private=True,
            owner=cls.superuser,
        )
        cls.authorized_user = User.objects.create_user("authorized")
        cls.unauthorized_user = User.objects.create_user("unauthorized")
        TopicGroupUser.objects.create(
            topic=cls.private_topic,
            group=TopicGroupUser.GroupChoices.common,
            user=cls.authorized_user,
        )

    def test_write_permission_on_private_topic(self):
        data = {
            "title": "test",
            "content": "test",
            "topic": self.private_topic.pk,
        }
        # 401 -> 권한없는 유저 토픽에 포스트 작성
        self.client.force_login(self.unauthorized_user)
        data["owner"] = self.authorized_user.pk
        res = self.client.post(reverse("post-list"), data=data)
        self.assertEqual(res.status_code, status.HTTP_401_UNAUTHORIZED)

        # 201 -> 권한있는 유저 토픽에 포스트 작성
        self.client.force_login(self.authorized_user)
        data["owner"] = self.authorized_user.pk
        res: HttpResponse = self.client.post(reverse("post-list"), data=data)
        self.assertEqual(res.status_code, status.HTTP_201_CREATED)
        data = json.loads(res.content)
        Post.objects.get(pk=data["id"])
