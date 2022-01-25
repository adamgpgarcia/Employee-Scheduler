from django.urls import path, include
from django.conf.urls import url
from rest_framework import routers
from rest_framework.authtoken.views import obtain_auth_token

from .views import product_list, message_list, shift_list, register_employee_view, CustomAuthToken, employee_list,employee_update_delete,shift_update_delete, schedule_list, schedule_update_delete, message_delete, company_get_put, chat_get_update, chat_list, timecard_list, timecard_update_delete, time_slot_list, time_slot_delete

#URL paths

urlpatterns = [
    #path('', include(router.urls)),
    path('login/', CustomAuthToken.as_view()),
    path('product/',product_list),

    path('message/',message_list),
    path('message/<int:id>/', message_delete),

    path('timecard/',timecard_list),
    path('timecard/<int:id>/', timecard_update_delete),


    path('employee/',employee_list),
    path('employee/<int:id>/', employee_update_delete),

    path('chat/', chat_list),
    path('chat/<int:id>/', chat_get_update),

    path('company/<int:id>/',company_get_put),

    path('shift/',shift_list),
    path('shift/<int:id>/',shift_update_delete),

    path('schedule/',schedule_list),
    path('schedule/<int:id>/',schedule_update_delete),

    path('timeslot/',time_slot_list),
    path('timeslot/<int:id>/',time_slot_delete),

    path('register/', register_employee_view),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    
]
