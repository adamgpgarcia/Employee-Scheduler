import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class EmployeeAccount {
  final int employeeID;
  final int dbID;
  final String username;
  final String firstName;
  final String lastName;
  int employeeType;
  String email;
  String phone;
  double hourlyWage;
  int scheduledHours;
  final bool isStaff;
  final bool isSupervisor;
  final bool isAdmin;
  //availability 

  EmployeeAccount({
    @required this.employeeID,
    @required this.dbID,
    @required this.username,
    @required this.firstName,
    @required this.lastName,
    @required this.employeeType,
    @required this.email,
    @required this.phone,
    @required this.hourlyWage,
    @required this.scheduledHours,
    @required this.isStaff,
    @required this.isSupervisor,
    @required this.isAdmin,
    // @required this.email,
    // @required this.phone,
    // @required this.callOffs,
    // @required this.hourlyWage,
    // @required this.startDate,
    // @required this.lateDays,
    // @required this.hours,
  });
}

// class EmployeeID {
//   final int employeeID;
//   int employeeType;
//   final String firstName;
//   final String lastName;

//   EmployeeID({
//     @required this.employeeID,
//     @required this.employeeType,
//     @required this.firstName,
//     @required this.lastName,
//   });
// }



class Employees with ChangeNotifier{

  List<EmployeeAccount> _employeeList = [];

  List<EmployeeAccount> get items {
  //example to have filtered return
  // if ( _showFavoritesOnly){
  //   return _items.where((prodItem) => prodItem.isFavorite).toList();
  // }
  return [..._employeeList];
  }

  int get employeeCount{
    return _employeeList == [] ? 0 : _employeeList.length;
  }


  List <EmployeeAccount> contactList(){
    List <EmployeeAccount>  sortedList = [];

    sortedList = _employeeList;
    sortedList.sort((a, b) => b.firstName.compareTo(a.firstName));

    return sortedList;
  }

  String getName (int empID){
    for(var employee in _employeeList){
      if(employee.employeeID == empID){
        return ("${employee.firstName} ${employee.lastName}");
      }
    }
    return null;
  }
  
  int getID (String employee){
    for(var name in _employeeList){
      if(name.firstName == employee){
        return name.employeeID;
      }
    }
    return null;
  }

  String getIntials (int empID){
    for(var employee in _employeeList){
      if(employee.employeeID == empID){
        return ("${employee.firstName[0]} ${employee.lastName[0]}");
      }
    }
    return null;
  }
  
  // int getID (String employee){
  //   for(var name in _employeeList){
  //     if(name.firstName == employee){
  //       return name.employeeID;
  //     }
  //   }
  //   return null;
  // }

  


  Future<void>getEmployees(String token) async {
    var headers = {
      'Content-Type' : 'application/json',
      'Authorization' : "token $token"
    };
    const url = 'http://35.233.225.216:8000/employee/';

    try{
      final response = await http.get(url, headers: headers);
      final loadedData = json.decode(response.body) as List<dynamic>;
      final List<EmployeeAccount> employeeList = [];

      for(int i = 0; i < loadedData.length; i++){
        
          var temp = EmployeeAccount(
            employeeID: loadedData[i]['id'],
            dbID:  loadedData[i]['employeeID'],
            username : loadedData[i]['username'],
            firstName : loadedData[i]['first_name'],
            lastName : loadedData[i]['last_name'],
            employeeType : loadedData[i]['employeeType'],
            email : loadedData[i]['email'],
            phone : loadedData[i]['phone'],
            hourlyWage : double.parse(loadedData[i]['hourlyWage']),
            scheduledHours : loadedData[i]['scheduledHours'],
            isStaff : loadedData[i]['is_staff'],
            isSupervisor : loadedData[i]['is_supervisor'],
            isAdmin : loadedData[i]['is_admin'],
          );
          employeeList.add(temp);
      }

      _employeeList = employeeList;
      notifyListeners();     
    } 
    catch(error){
      throw(error);
    }    
  }


   Future<void>updateEmployees(String token, int id, EmployeeAccount editiedEmployee) async {
    var headers = {
      'Content-Type' : 'application/json',
      'Authorization' : "token $token"
    };

    final index = _employeeList.indexWhere((item) => item.employeeID == editiedEmployee.employeeID);

    final url = 'http://35.233.225.216:8000/employee/$id/';

    try{
      final response = await http.put(url,headers: headers, body: json.encode({
        'username' : editiedEmployee.username,
        'employeeID' : editiedEmployee.dbID,
        'first_name' : editiedEmployee.firstName,
        'last_name' : editiedEmployee.lastName,
        'employeeType' : editiedEmployee.employeeType,
        'email' : editiedEmployee.email,
        'phone' : editiedEmployee.phone,
        'hourlyWage' : editiedEmployee.hourlyWage,
        'scheduledHours' : editiedEmployee.scheduledHours,
        'is_staff' : editiedEmployee.isStaff,
        'is_supervisor' : editiedEmployee.isSupervisor,
        'is_admin' : editiedEmployee.isAdmin, 
      }));
      print(response.body);
          
      _employeeList[index] = editiedEmployee ;
      notifyListeners();
    } 
    catch(error){
      throw(error);
    }    
  }

  Future<void>createEmployee(String token, String password, EmployeeAccount employee) async {
    var headers = {
      'Content-Type' : 'application/json',
      'Authorization' : "token $token"
    };

    final url = 'http://35.233.225.216:8000/register/';

    return http.post(url,headers: headers, body: json.encode({
        'username' : employee.username,
        'employeeID' : employee.employeeID,
        'first_name' : employee.firstName,
        'last_name' : employee.lastName,
        'password' : password,
        'employeeType' : employee.employeeType,
        'email' : employee.email,
        'phone' : employee.phone,
        'hourlyWage' : employee.hourlyWage,
        'scheduledHours' : employee.scheduledHours,
        'is_staff' : employee.isStaff,
        'is_supervisor' : employee.isSupervisor,
        'is_admin' : employee.isAdmin, 
      })).then((response) {
        EmployeeAccount temp = EmployeeAccount(
            dbID: json.decode(response.body)['id'],
            username : employee.username,
            employeeID: json.decode(response.body)['id'],
            firstName : employee.firstName,
            lastName : employee.lastName,
            employeeType : employee.employeeType,
            email : employee.email,
            phone :  employee.phone,
            hourlyWage : employee.hourlyWage,
            scheduledHours : employee.scheduledHours,
            isStaff :  employee.isStaff,
            isSupervisor : employee.isSupervisor,
            isAdmin : employee.isAdmin, 
        );
     print(response.body);
          
     _employeeList.add(employee);
     notifyListeners();
   }).catchError((onError) {
      throw onError;
    });  
  }


  bool isAdmin(userID){
    for(int i = 0; i < _employeeList.length; i++){
      if(_employeeList[i].employeeID == userID){
        if(_employeeList[i].isAdmin == true){
          return true;
        }
      }
    }
    return false;
  }
  bool isSupervisor(userID){
    for(int i = 0; i < _employeeList.length; i++){
      if(_employeeList[i].employeeID == userID){
        if(_employeeList[i].isSupervisor == true){
          return true;
        }
      }
    }
    return false;
  }


  Future<void> deleteEmployee(int id, String token) async{
    var headers = {
      'Authorization' : "token $token",
      'Content-Type' : 'application/json'
    };
  
    final employeeIndex = _employeeList.indexWhere((item) => item.employeeID == id);
   
    try{
      final url = 'http://35.233.225.216:8000/employee/$id/'; 
      await http.delete(url, headers: headers);
      
      _employeeList.removeAt(employeeIndex);
      notifyListeners();

    } catch(error){
       print(error);
      throw(error);
    }
  }

  // Future<void> createEmployee(String token) {
  //   var auth = Provider.of<Auth>(context, listen: false).token;
  //   var headers = {
  //     'Content-Type' : 'application/json'
  //     'Token' : auth.token
  //   };
  //   DateTime tempTime = message.sentTime;
  //   String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(tempTime);

  //   const url = 'http://35.233.225.216:8000/message/'; 
  //   return http.post(url, headers: headers, body: json.encode({
  //     'senderID' : message.senderID,
  //     'recieverID' : message.recieverID,
  //     'sentTime' : formattedDate,
  //     'message': message.message,
  //   }),).then((response){
  //       print(json.decode(response.body));
  //       final newMessage = MessageModel(
  //         messageID: json.decode(response.body)['id'],
  //         senderID : message.senderID,
  //         recieverID : message.recieverID,
  //         sentTime : message.sentTime,
  //         message : message.message,
  //       );
  //     _messageList.add(newMessage);
  //     //_items.insert(0, newProduct); //insert at the begining of the list
  //     notifyListeners();

  //   }).catchError((onError){
  //     throw onError;
  //   });
        //print(json.decode(response.body));  
  }








  // //returns list of employee names, id, and type
  // List <EmployeeID> returnEmployees(){
  //   List <EmployeeID> list = []; 
  //   for(var employee in _employeeList){
  //     var temp = EmployeeID(
  //       employeeID: employee.employeeID,
  //       employeeType: employee.employeeType,
  //       firstName: employee.firstName,
  //       lastName: employee.lastName
  //     );
  //     list.add(temp);
  //   }
  //   return list;
  // }
