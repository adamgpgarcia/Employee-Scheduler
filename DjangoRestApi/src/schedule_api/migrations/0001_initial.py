# Generated by Django 3.0.7 on 2022-01-25 03:05

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import phone_field.models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Employee_Account',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('username', models.CharField(max_length=30, unique=True)),
                ('employeeID', models.IntegerField()),
                ('first_name', models.CharField(max_length=30)),
                ('last_name', models.CharField(max_length=30)),
                ('employeeType', models.IntegerField(default=1)),
                ('email', models.EmailField(default='default', max_length=254)),
                ('phone', phone_field.models.PhoneField(blank=True, default=1234567890, help_text='Contact phone number', max_length=31)),
                ('hourlyWage', models.DecimalField(decimal_places=2, default=0, max_digits=5)),
                ('scheduledHours', models.IntegerField(default=0)),
                ('date_added', models.DateTimeField(auto_now_add=True, verbose_name='date added')),
                ('last_login', models.DateTimeField(auto_now=True, verbose_name='last login')),
                ('is_staff', models.BooleanField(default=True)),
                ('is_supervisor', models.BooleanField(default=False)),
                ('is_admin', models.BooleanField(default=False)),
                ('is_superuser', models.BooleanField(default=False)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Chat',
            fields=[
                ('chatID', models.AutoField(primary_key=True, serialize=False)),
                ('recipients', models.ManyToManyField(blank=True, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Company',
            fields=[
                ('companyID', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=30)),
                ('phone', phone_field.models.PhoneField(blank=True, help_text='Contact phone number', max_length=31)),
                ('street', models.CharField(max_length=50)),
                ('city', models.CharField(max_length=30)),
                ('zipCode', models.IntegerField()),
                ('payFrequency', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='Product',
            fields=[
                ('productID', models.IntegerField()),
                ('title', models.CharField(max_length=30)),
                ('price', models.DecimalField(decimal_places=2, max_digits=6)),
                ('description', models.AutoField(primary_key=True, serialize=False)),
                ('imageUrl', models.CharField(max_length=300)),
                ('isFavorite', models.BooleanField()),
            ],
        ),
        migrations.CreateModel(
            name='Schedule',
            fields=[
                ('scheduleID', models.AutoField(primary_key=True, serialize=False)),
                ('startPeriod', models.DateTimeField()),
                ('endPeriod', models.DateTimeField()),
                ('timecardDue', models.DateTimeField()),
                ('companyID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='schedule_api.Company')),
            ],
        ),
        migrations.CreateModel(
            name='TimeSlot',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('startTime', models.DateTimeField()),
                ('endTime', models.DateTimeField()),
                ('day', models.CharField(max_length=30)),
                ('employeeID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Timecard',
            fields=[
                ('timecardID', models.AutoField(primary_key=True, serialize=False)),
                ('employeeID', models.IntegerField()),
                ('scheduleID', models.IntegerField()),
                ('regularTime', models.DecimalField(decimal_places=2, max_digits=5)),
                ('overTime', models.DecimalField(decimal_places=2, max_digits=4)),
                ('doubleTime', models.DecimalField(decimal_places=2, max_digits=4)),
                ('lunchTime', models.DecimalField(decimal_places=2, max_digits=5)),
                ('companyID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='schedule_api.Company')),
            ],
        ),
        migrations.CreateModel(
            name='Shift',
            fields=[
                ('shiftID', models.AutoField(primary_key=True, serialize=False)),
                ('employeeID', models.IntegerField()),
                ('startTime', models.DateTimeField()),
                ('endTime', models.DateTimeField()),
                ('startLunch', models.DateTimeField()),
                ('endLunch', models.DateTimeField()),
                ('position', models.CharField(max_length=30)),
                ('release', models.BooleanField()),
                ('confirmed', models.BooleanField()),
                ('scheduleID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='schedule_api.Schedule')),
            ],
        ),
        migrations.CreateModel(
            name='Message',
            fields=[
                ('messageID', models.AutoField(primary_key=True, serialize=False)),
                ('senderID', models.IntegerField()),
                ('receiverID', models.IntegerField()),
                ('sentTime', models.DateTimeField()),
                ('message', models.CharField(max_length=300)),
                ('notification', models.BooleanField(default=False)),
                ('chatID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='schedule_api.Chat')),
            ],
        ),
    ]