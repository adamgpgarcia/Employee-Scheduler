import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/schedules.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Auth with ChangeNotifier{


  String _token;
  DateTime _expireDate;
  int _userId;

  bool get isAuth{
      return token != null;
  }

  String get token{
    if(_token != null){
      return _token;
    }
    else{
      return null;
    }
  }

  void logout() {
    _token = null;
    _userId = null;
    notifyListeners();
  }

  int get user{
    return _userId;
  }

  Future<void> login(String username, String password) async{
    var headers = {
      'Content-Type' : 'application/json'
    };
    const url = 'http://35.233.225.216:8000/login/'; 
    try{
      final response = await http.post(url, headers: headers, body: json.encode({
        'username' : username,
        'password' : password,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if(responseData['non_field_errors'] != null){
        throw responseData['non_field_errors'];
      }
      _token = responseData['token'];
      _userId = responseData['user_id'];
  
      notifyListeners();
    }
    catch (error){
      throw error;
    }
  

  }

   
}