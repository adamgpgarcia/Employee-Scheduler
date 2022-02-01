import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/schedules.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//this auth provider
class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  int _userId;

  //checks if token does not equal null
  bool get isAuth {
    return token != null;
  }

  //this function returns the token
  String get token {
    if (_token != null) {
      return _token;
    } else {
      return null;
    }
  }

  //this function logs the user out
  void logout() {
    _token = null;
    _userId = null;
    notifyListeners();
  }

  //returns the user id
  int get user {
    return _userId;
  }

  //this functin logs the user into the database and saves the access token
  Future<void> login(String username, String password) async {
    var headers = {'Content-Type': 'application/json'};
    const url = 'http://35.233.225.216:8000/login/';
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(
          {
            'username': username,
            'password': password,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['non_field_errors'] != null) {
        throw responseData['non_field_errors'];
      }
      _token = responseData['token'];
      _userId = responseData['user_id'];

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
