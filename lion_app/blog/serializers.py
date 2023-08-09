import os

from pymongo import MongoClient
from rest_framework import serializers

MONGO_HOST = os.getenv("MONGO_HOST", "mongo")
client = MongoClient(host=MONGO_HOST)
db = client.likelion

class BlogSerializer(serializers.Serializer):
    title = serializers.CharField(max_length=100)
    content = serializers.CharField()
    author = serializers.CharField(max_length=100)

    def create(self, validated_data):
        return db.blogs.insert_one(validated_data)