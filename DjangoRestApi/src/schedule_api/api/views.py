from rest_framework import status, viewsets, generics, mixins
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.decorators import api_view, permission_classes
from rest_framework.parsers import JSONParser
from rest_framework.authtoken.models import Token
from rest_framework.permissions import IsAuthenticated
from rest_framework.authtoken.views import ObtainAuthToken

from schedule_api.models import Shift, Product, Message, Employee_Account,Schedule, Timecard, Company, Chat, TimeSlot
from .serializers import ShiftSerializer, ProductSerializer, MessageSerializer, RegisterEmployeeSerializer, EmployeeAccountSerializer, ScheduleSerializer, TimecardSerializer, CompanySerializer, ChatSerializer, TimeSlotSerializer

#CRUD functions

@api_view(['POST',])
@permission_classes((IsAuthenticated,))
def register_employee_view(request):

    if request.method == 'POST':
        serializer = RegisterEmployeeSerializer(data=request.data)
        data = {}
        if serializer.is_valid():
            account = serializer.save()
            data['response'] = "Successfully registered a new user."
            data['username'] = account.username
            data['first_name'] = account.first_name

        else:
            data = serializer.errors
        return Response(data)

@api_view(['GET',])
@permission_classes((IsAuthenticated,))
def employee_list(request):
        
    if request.method == 'GET':
        employees = Employee_Account.objects.all()
        serializer = EmployeeAccountSerializer(employees, many = True)
        return Response(serializer.data)

@api_view(['PUT','DELETE' ])
@permission_classes((IsAuthenticated,))
def employee_update_delete(request,id):
    
    try:
        employee = Employee_Account.objects.get(employeeID=id)
    except Employee_Account.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'PUT':
        serializer = EmployeeAccountSerializer(employee, data=request.data)
        data = {}
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        operation = employee.delete()
        data = {}
        if operation:
            data['success'] = "delete successful"
        else:
            data['failure'] = "delete failed"
        
        return Response(data=data)


@api_view(['GET','POST'])
@permission_classes((IsAuthenticated,))
def message_list(request):
        
    if request.method == 'GET':
        messages = Message.objects.all()
        serializer = MessageSerializer(messages, many = True)
        return Response(serializer.data)

    elif request.method == 'POST':
        data = JSONParser().parse(request)
        serializer = MessageSerializer(data = data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)


@api_view(['DELETE' ])
@permission_classes((IsAuthenticated,))
def message_delete(request,id):
    
    try:
        MessageID = Message.objects.get(messageID=id)
    except MessageID.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'DELETE':
        operation = MessageID.delete()
        data = {}
        if operation:
            data['success'] = "delete successful"
        else:
            data['failure'] = "delete failed"
        
        return Response(data=data)


@api_view(['GET','POST'])
@permission_classes((IsAuthenticated,))
def time_slot_list(request):
        
    if request.method == 'GET':
        timeSlots = TimeSlot.objects.all()
        serializer = TimeSlotSerializer(timeSlots, many = True)
        return Response(serializer.data)

    elif request.method == 'POST':
        data = JSONParser().parse(request)
        serializer = TimeSlotSerializer(data = data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)


@api_view(['DELETE' ])
@permission_classes((IsAuthenticated,))
def time_slot_delete(request,id):
    
    try:
        timeSlot = TimeSlot.objects.get(id=id)
    except timeSlot.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'DELETE':
        operation = timeSlot.delete()
        data = {}
        if operation:
            data['success'] = "delete successful"
        else:
            data['failure'] = "delete failed"
        
        return Response(data=data)

@api_view(['GET','POST'])
@permission_classes((IsAuthenticated,))
def schedule_list(request):
        
    if request.method == 'GET': 
        schedules = Schedule.objects.all()
        serializer = ScheduleSerializer(schedules, many = True)
        return Response(serializer.data)

    elif request.method == 'POST':
        data = JSONParser().parse(request)
        serializer = ScheduleSerializer(data = data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT','DELETE' ])
@permission_classes((IsAuthenticated,))
def schedule_update_delete(request,id):
    
    try:
        scheduleID = Schedule.objects.get(scheduleID=id)
    except Schedule.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'PUT':
        serializer = ScheduleSerializer(scheduleID, data=request.data)
        data = {}
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        operation = scheduleID.delete()
        data = {}
        if operation:
            data['success'] = "delete successful"
        else:
            data['failure'] = "delete failed"
        
        return Response(data=data)


@api_view(['GET','POST'])
@permission_classes((IsAuthenticated,))
def chat_list(request):
        
    if request.method == 'GET': 
        chats = Chat.objects.all()
        serializer = ChatSerializer(chats, many = True)
        return Response(serializer.data)

    elif request.method == 'POST':
        data = JSONParser().parse(request)
        serializer = ChatSerializer(data = data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
@permission_classes((IsAuthenticated,))
def chat_get_update(request,id):
    
    try:
        chatID = Chat.objects.get(chatID=id)
    except chatID.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET': 
        chats = Chat.objects.all()
        serializer = ChatSerializer(chats, many = True)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = ChatSerializer(chatID, data=request.data)
        data = {}
        if serializer.is_valid():
            serializer.save()

            count = chatID.recipients.all().count()
            if count == 0:
                operation = chatID.delete()
                data = {}
                if operation:
                    data['success'] = "delete successful"
                else:
                    data['failure'] = "delete failed"

            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

  
@api_view(['GET','POST'])
@permission_classes((IsAuthenticated,))
def shift_list(request):
        
    if request.method == 'GET':
        shifts = Shift.objects.all()
        serializer = ShiftSerializer(shifts, context={'request': request},many = True)
        return Response(serializer.data)

    elif request.method == 'POST':
        data = JSONParser().parse(request)
        serializer = ShiftSerializer(data = data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)


@api_view(['PUT','DELETE' ])
@permission_classes((IsAuthenticated,))
def shift_update_delete(request,id):
    
    try:
        shiftID = Shift.objects.get(shiftID=id)
    except shiftID.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'PUT':
        serializer = ShiftSerializer(shiftID, data=request.data)
        data = {}
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        operation = shiftID.delete()
        data = {}
        if operation:
            data['success'] = "delete successful"
        else:
            data['failure'] = "delete failed"
        
        return Response(data=data)

   
@api_view(['GET','POST'])
@permission_classes((IsAuthenticated,))
def timecard_list(request):
        
    if request.method == 'GET':
        timecards = Timecard.objects.all()
        serializer = TimecardSerializer(timecards, many = True)
        return Response(serializer.data)

    elif request.method == 'POST':
        data = JSONParser().parse(request)
        serializer = TimecardSerializer(data = data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT','DELETE' ])
@permission_classes((IsAuthenticated,))
def timecard_update_delete(request,id):
    
    try:
        timecardID = Timecard.objects.get(timecardID=id)
    except timecardID.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'PUT':
        serializer = TimecardSerializer(timecardID, data=request.data)
        data = {}
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        operation = timecardID.delete()
        data = {}
        if operation:
            data['success'] = "delete successful"
        else:
            data['failure'] = "delete failed"
        
        return Response(data=data)


@api_view(['GET','PUT'])
@permission_classes((IsAuthenticated,))
def company_get_put(request,id):

    try:
        tempID = Company.objects.get(companyID=id)
    except tempID.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)\
    
    if request.method == 'GET':
        serializer = CompanySerializer(tempID)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = CompanySerializer(tempID, data=request.data)
        data = {}
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors,status=status.HTTP_400_BAD_REQUEST)

        
class CustomAuthToken(ObtainAuthToken):

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        return Response({
            'token': token.key,
            'user_id': user.pk,
        })
  
@api_view(['GET',])
def product_list(request):
        
    if request.method == 'GET':
        products = Product.objects.all()
        serializer = ProductSerializer(products, many = True)
        return Response(serializer.data)
