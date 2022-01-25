from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

# Registering Admin models

from .models import Shift, Product, Message, Employee_Account, Schedule, Company, Timecard, Chat,TimeSlot

admin.site.register(Shift)
admin.site.register(Schedule)   
admin.site.register(Product)
admin.site.register(Message)  
admin.site.register(Company)  
admin.site.register(Timecard)
admin.site.register(Chat)
admin.site.register(TimeSlot)

class AccountAdmin(UserAdmin):
    list_display = ('id','username', 'employeeID', 'first_name', 'last_name', 'date_added', 'last_login', 'is_staff','is_supervisor', 'is_admin', 'is_superuser')
    search_fields = ('username', 'first_name', 'last_name')
    readonly_fields = ('date_added', 'last_login')

    filter_horizontal = ()
    list_filter = ()
    fieldsets = ()

admin.site.register(Employee_Account, AccountAdmin)