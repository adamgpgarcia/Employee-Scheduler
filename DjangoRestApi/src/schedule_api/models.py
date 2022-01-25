from django.db import models
from phone_field import PhoneField
from django.utils import timezone
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django.conf import settings
from django.db.models.signals import post_save
from django.dispatch import receiver 
from rest_framework.authtoken.models import Token 

#Models and associated functions

class AccountManager(BaseUserManager):
    def create_user(self, username, employeeID, first_name, last_name, employeeType, email, phone, hourlyWage, scheduledHours,is_staff, is_supervisor, is_admin, password=None):
        if not username:
            raise ValueError("Users must have an username")
        if not employeeID:
            raise ValueError("Users must have an employeeID")
        if not employeeType:
            raise ValueError("Users must have an employeeID")
        if not first_name:
            raise ValueError("Users must have an first name")
        if not last_name:
            raise ValueError("Users must have an last name")

        user = self.model(
            username=username,
            employeeID=employeeID,
            first_name=first_name,
            last_name=last_name,
            employeeType=employeeType,
            email=email,
            phone=phone,
            hourlyWage=hourlyWage,
            scheduledHours=scheduledHours,
            is_staff=is_staff,
            is_supervisor=is_supervisor,
            is_admin=is_admin
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, first_name, last_name, password):

        user = self.create_user(
            username=username,
            first_name=first_name,
            last_name=last_name,
            password=password
        )

        user.is_admin = True
        user.is_supervisor = True
        user.is_superuser = True
        user.save(using=self._db)
        return user

    
class Employee_Account(AbstractBaseUser):
    username    = models.CharField(max_length=30, unique=True)
    employeeID  = models.IntegerField()
    first_name  = models.CharField(max_length=30)
    last_name   = models.CharField(max_length=30)
    employeeType = models.IntegerField(default=1)
    email = models.EmailField(max_length=254, default="default")
    phone = PhoneField(blank=True, help_text='Contact phone number', default=1234567890)
    hourlyWage = models.DecimalField(max_digits=5, decimal_places=2,default=0)
    scheduledHours = models.IntegerField(default=0)
    date_added  = models.DateTimeField(verbose_name='date added',auto_now_add=True)
    last_login  = models.DateTimeField(verbose_name='last login', auto_now=True)
    is_staff   = models.BooleanField(default=True)
    is_supervisor = models.BooleanField(default=False)
    is_admin    = models.BooleanField(default=False)
    is_superuser= models.BooleanField(default=False)

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['employeeID','first_name', 'last_name', 'employeeType', 'email','phone','hourlyWage','scheduledHour','is_staff', 'is_supervisor', 'is_admin']

    objects = AccountManager()

    def __str__(self):
        return self.username

    def has_perm(self, perm, obj=None):
        return self.is_admin
    
    def has_module_perms(self, app_label):
        return True

class Product(models.Model):
    productID = models.IntegerField()
    title = models.CharField( max_length = 30, null=False)
    price = models.DecimalField(max_digits=6,decimal_places=2) 
    description = models.AutoField(primary_key=True)
    imageUrl = models.CharField( max_length = 300, null=False)
    isFavorite = models.BooleanField()
    
    def __str__(self):
        return str(self.title)

class Chat(models.Model):
    chatID = models.AutoField(primary_key=True)
    recipients = models.ManyToManyField(Employee_Account, blank=True)

    def __str__(self):
        return str(self.chatID)
    
class Message(models.Model):
    messageID = models.AutoField(primary_key=True)
    chatID = models.ForeignKey(Chat, on_delete=models.CASCADE) 
    senderID = models.IntegerField()
    receiverID = models.IntegerField()
    sentTime = models.DateTimeField()
    message = models.CharField(max_length = 300)
    notification = models.BooleanField(default=False)

    def __str__(self):
        return str(self.message)


class TimeSlot(models.Model):
    employeeID = models.ForeignKey(Employee_Account, on_delete=models.CASCADE) 
    startTime = models.DateTimeField()
    endTime = models.DateTimeField()
    day = models.CharField(max_length = 30, null=False)

    
    def __str__(self):
        return str(self.employeeID)   


class Company(models.Model):
    companyID = models.AutoField(primary_key=True)
    name = models.CharField( max_length = 30, null=False)
    phone = PhoneField(blank=True, help_text='Contact phone number')
    street = models.CharField( max_length = 50, null=False)
    city = models.CharField( max_length = 30, null=False)
    zipCode = models.IntegerField()
    payFrequency = models.IntegerField()

    def __str__(self):
        return str(self.companyID)

class Timecard(models.Model):
    timecardID = models.AutoField(primary_key=True)
    employeeID = models.IntegerField()
    companyID = models.ForeignKey(Company, on_delete=models.CASCADE) 
    scheduleID = models.IntegerField()
    regularTime = models.DecimalField(max_digits=5, decimal_places=2)
    overTime = models.DecimalField(max_digits=4, decimal_places=2)
    doubleTime = models.DecimalField(max_digits=4, decimal_places=2)
    lunchTime = models.DecimalField(max_digits=5, decimal_places=2)

    def __str__(self):
        return str(self.timecardID)


class Schedule(models.Model):
    scheduleID = models.AutoField(primary_key=True)
    companyID = models.ForeignKey(Company, on_delete=models.CASCADE) 
    startPeriod = models.DateTimeField()
    endPeriod = models.DateTimeField()
    timecardDue = models.DateTimeField()

    def __str__(self):
        return str(self.scheduleID)

class Shift(models.Model):
    shiftID = models.AutoField(primary_key=True)
    scheduleID = models.ForeignKey(Schedule, on_delete=models.CASCADE)
    employeeID = models.IntegerField()
    startTime = models.DateTimeField()
    endTime = models.DateTimeField()
    startLunch = models.DateTimeField()
    endLunch = models.DateTimeField()
    position = models.CharField( max_length = 30, null=False)
    release = models.BooleanField()
    confirmed = models.BooleanField()

    def __str__(self):
        return str(self.shiftID)


@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Token.objects.create(user=instance)
