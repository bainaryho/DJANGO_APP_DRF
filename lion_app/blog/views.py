from pymongo import MongoClient
from rest_framework.viewsets import ViewSet
from rest_framework.response import Response
from rest_framework import status

from .serializers import BlogSerializer


client = MongoClient(host="mongo")
db = client.likelion

class BlogViewSet(ViewSet):
    serializer_class = BlogSerializer

    def list(self, request):
        return Response()
    
    def create(self, request):
        """
        request.data = {
            "title": "My second blog",
            "content": "This is my second blog",
            "author": "lion",
        }
        """
        serializer = BlogSerializer(data=request.data)
        if serializer.is_valid():
            serializer.create(serializer.validated_data)
            return Response(status=status.HTTP_201_CREATED, data=serializer.data)
        else:
            return Response(status=status.HTTP_400_BAD_REQUEST, data=serializer.errors)
    
    def retrieve(self, request):
        ...
    
    def destroy(self, request):
        ...

def create_blog(request) -> bool:
    blog = {
        "title": "My second blog",
        "content": "This is my second blog",
        "author": "lion",
    }
    try:
        db.blogs.insert_one(blog)
        return True
    except Exception as e:
        print(e)
        return False

def update_blog():
    ...

def delete_blog():
    ...

def read_blog():
    ...