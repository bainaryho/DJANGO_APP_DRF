import json

from django.contrib.auth.models import User
from django.urls import reverse
from django.http import HttpResponse
from rest_framework.test import APITestCase
from rest_framework import status

from .models import Topic, Post, TopicGroupUser


class PostTest(APITestCase):
    @classmethod
    def setUpTestData(cls):
        cls.superuser = User.objects.create_superuser("superuser")
        cls.private_topic = Topic.objects.create(
            name="private topic",
            is_private=True,
            owner=cls.superuser,
        )
        cls.public_topic = Topic.objects.create(
            name="public topic",
            is_private=False,
            owner=cls.superuser,
        )

        # Posts on private topic
        for i in range(5):
            Post.objects.create(
                topic=cls.private_topic,
                title=f"{i+1}",
                content=f"{i+1}",
                owner=cls.superuser,
            )
        # Posts on public topic
        for i in range(5):
            Post.objects.create(
                topic=cls.public_topic,
                title=f"{i+1}",
                content=f"{i+1}",
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

        # when unauthorized user tries to write a post on Topic => fail. 401
        self.client.force_login(self.unauthorized_user)
        res = self.client.post(reverse("post-list"), data=data)
        self.assertEqual(res.status_code, status.HTTP_401_UNAUTHORIZED)

        # when authorized user tries to write a post on Topic => success. 201
        self.client.force_login(self.authorized_user)
        res: HttpResponse = self.client.post(reverse("post-list"), data=data)
        self.assertEqual(res.status_code, status.HTTP_201_CREATED)
        res_data = json.loads(res.content)
        Post.objects.get(pk=res_data["id"])

        # Owner가 쓸수있는지 테스트
        self.client.force_login(self.superuser)
        res = self.client.post(reverse("post-list"), data=data)
        self.assertEqual(res.status_code, status.HTTP_201_CREATED)

        # admin이 쓸수있는지 테스트
        admin = User.objects.create_user("admin")  # admin유저 생성
        # 권한부여
        TopicGroupUser.objects.create(
            topic=self.private_topic,
            group=TopicGroupUser.GroupChoices.admin,
            user=admin,
        )
        self.client.force_login(admin)
        res = self.client.post(reverse("post-list"), data=data)
        self.assertEqual(res.status_code, status.HTTP_201_CREATED)

    def test_read_permission_on_topics(self):
        # read public topic
        # unauthorized user requests => 200. public topic's posts
        self.client.force_login(self.unauthorized_user)
        res = self.client.get(reverse("topic-posts", args=[self.public_topic.pk]))
        self.assertEqual(res.status_code, status.HTTP_200_OK)
        data = json.loads(res.content)
        posts_n = Post.objects.filter(topic=self.public_topic).count()
        self.assertEqual(len(data), posts_n)

        # read private topic
        # unauthorized user requests => 401.
        self.client.force_login(self.unauthorized_user)
        res = self.client.get(reverse("topic-posts", args=[self.private_topic.pk]))
        self.assertEqual(res.status_code, status.HTTP_401_UNAUTHORIZED)
        # authorized user requests => 200. private topic's posts
        self.client.force_login(self.authorized_user)
        res = self.client.get(reverse("topic-posts", args=[self.private_topic.pk]))
        self.assertEqual(res.status_code, status.HTTP_200_OK)
        data = json.loads(res.content)
        posts_n = Post.objects.filter(topic=self.private_topic).count()
        self.assertEqual(len(data), posts_n)

    def test_read_permission_on_posts(self):
        # 디테일에 대해서도 테스트, id값으로 조회하는것
        self.client.force_login(self.unauthorized_user)
        public_post = Post.objects.filter(topic=self.public_topic).first()
        res = self.client.get(reverse("post-detail", args=[public_post.pk]))
        self.assertEqual(res.status_code, status.HTTP_200_OK)

        self.client.force_login(self.unauthorized_user)  # 로그인-unauthorized_user
        private_post = Post.objects.filter(
            topic=self.private_topic
        ).first()  # 위에 작성한 Post의 첫번째
        res = self.client.get(reverse("post-detail", args=[private_post.pk]))  # 음
        self.assertEqual(res.status_code, status.HTTP_401_UNAUTHORIZED)

        self.client.force_login(self.authorized_user)
        private_post = Post.objects.filter(topic=self.private_topic).first()
        res = self.client.get(reverse("post-detail", args=[private_post.pk]))
        self.assertEqual(res.status_code, status.HTTP_200_OK)
