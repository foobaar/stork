# -*- coding: utf-8 -*-
# Generated by Django 1.11.12 on 2019-09-18 03:59
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('storkbabyapp', '0004_auto_20190918_0352'),
    ]

    operations = [
        migrations.CreateModel(
            name='userExperienceMapping',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('education', models.CharField(max_length=200)),
                ('experience', models.IntegerField(default=200)),
                ('userID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='userexperiencemapping_userID', to='storkbabyapp.users')),
            ],
        ),
    ]
