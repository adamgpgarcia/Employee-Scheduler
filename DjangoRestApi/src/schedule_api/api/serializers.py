from rest_framework import serializers
from django.db import models
from schedule_api.models import Shift, Product, Message, Employee_Account, Company, Timecard, Schedule, Chat, TimeSlot

### Model Serializers 

class RegisterEmployeeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Employee_Account
        fields = ['username', 'employeeID', 'first_name', 'last_name', 'employeeType', 'email', 'phone', 'hourlyWage','scheduledHours','is_staff', 'is_supervisor', 'is_admin', 'password'] # employeeType','email', 'phone', 'callOffs', 'hourlyWage', 'hourlyWage', 'startDate', 'lateDays', 'hours']
        extra_kwargs = {'password': {'write_only': True}}


    def save(self):
        #register and return a new user
        account = Employee_Account(
            username=self.validated_data['username'],
            employeeID=self.validated_data['employeeID'],
            first_name=self.validated_data['first_name'],
            last_name=self.validated_data['last_name'],
            employeeType=self.validated_data['employeeType'],
            email=self.validated_data['email'],
            phone=self.validated_data['phone'],
            hourlyWage=self.validated_data['hourlyWage'],
            scheduledHours=self.validated_data['scheduledHours'],
            is_staff=self.validated_data['is_staff'],
            is_supervisor=self.validated_data['is_supervisor'],
            is_admin=self.validated_data['is_admin']

        )

        account.set_password(self.validated_data['password'])
        account.save()

        return account

class EmployeeAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Employee_Account
        fields = ['id', 'username', 'employeeID', 'first_name', 'last_name', 'employeeType', 'email', 'phone', 'hourlyWage', 'scheduledHours', 'date_added','is_staff', 'is_supervisor', 'is_admin'] 
        
class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['id','productID', 'title', 'price', 'description', 'imageUrl','isFavorite']

class TimeSlotSerializer(serializers.ModelSerializer):
    class Meta:
        model = TimeSlot
        fields = ['id','employeeID', 'startTime', 'endTime', 'day']

class MessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Message
        fields = ['messageID','chatID', 'senderID', 'receiverID', 'sentTime', 'message', 'notification']

class ScheduleSerializer(serializers.ModelSerializer):
    #shifts = serializers.PrimaryKeyRelatedField(many=True, read_only=True)

    class Meta:
        model = Schedule
        fields = ['scheduleID', 'companyID', 'startPeriod', 'endPeriod', 'timecardDue']

class CompanySerializer(serializers.ModelSerializer):
    class Meta:
        model = Company
        fields = ['companyID', 'name', 'phone', 'street', 'zipCode', 'payFrequency']

class ChatSerializer(serializers.ModelSerializer):
 
    class Meta:
        model = Chat
        fields = ['chatID', 'recipients']

class TimecardSerializer(serializers.ModelSerializer):
    class Meta:
        model = Timecard
        fields = ['timecardID', 'employeeID', 'companyID', 'scheduleID', 'regularTime', 'overTime', 'doubleTime', 'lunchTime']

class ShiftSerializer(serializers.ModelSerializer):
 
    class Meta:
        model = Shift
        fields = ['shiftID', 'scheduleID', 'employeeID', 'startTime','endTime', 'startLunch', 'endLunch', 'position', 'release', 'confirmed']

   
