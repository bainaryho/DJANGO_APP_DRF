# Generated by Django 4.2.4 on 2023-08-30 01:31

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("Forum", "0002_post_image_url_alter_topicgroupuser_topic"),
    ]

    operations = [
        migrations.AlterField(
            model_name="post",
            name="image_url",
            field=models.URLField(blank=True, null=True),
        ),
    ]
