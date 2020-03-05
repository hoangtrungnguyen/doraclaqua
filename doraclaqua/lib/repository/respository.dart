import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:doraclaqua/model/login_data.dart';
import 'package:doraclaqua/model/user.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "https://doralaqua.com/wp-json";

class Client {
  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return true;
    }
    return false;
  }

  static Future<http.Response> authentication(LoginData user) async {
    final authenticationUrl = "$baseUrl/jwt-auth/v1/token";
    http.Response response = await http.post(
      authenticationUrl,
      headers: <String, String>{
        'Content-Type': 'application/json;  charset=UTF-8',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'username': user.username,
        'password': user.password
      }),
    );
    return response;
  }

  static Future<http.Response> registerNewUser(User user) async {
    final authenticationUrl = "$baseUrl/wp/v2/users/register";
    http.Response response = await http.post(
      authenticationUrl,
      headers: <String, String>{
        'Content-Type': 'application/json;  charset=UTF-8',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'username': user.userName,
        'password': user.password,
        'email': user.userEmail,
        'role': 'subscriber'
      }),
    );
    return response;
  }

  static Future<http.Response> requestNewPass(String name) async {
    final authenticationUrl = "$baseUrl/wp/v2/users/lostpassword";
    http.Response response = await http.post(
      authenticationUrl,
      headers: <String, String>{
        'Content-Type': 'application/json;  charset=UTF-8',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        "user_login": name,
      }),
    );
    return response;
  }
}
