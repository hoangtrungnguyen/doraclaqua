import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

  static Future<http.Response> getRequestCount(String token) async {
    String testToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvZG9yYWxhcXVhLmNvbSIsImlhdCI6MTU4MzIwNDc2OSwibmJmIjoxNTgzMjA0NzY5LCJleHAiOjE1ODM4MDk1NjksImRhdGEiOnsidXNlciI6eyJpZCI6IjExIn19fQ.0H4ZLd5etxnPySc9RoTJed21kd4SljY60PerN_rt2LA";
    final historyUrl = "$baseUrl/wp/v2/app/history/total";
    http.Response response = await http.get(
      historyUrl,
      headers: <String, String>{
        '${HttpHeaders.authorizationHeader}':'Bearer $testToken' ,
      },
    );
    return response;
  }

  static Future<http.Response> getAllRequest(String token) async {
    String testToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvZG9yYWxhcXVhLmNvbSIsImlhdCI6MTU4MzIwNDc2OSwibmJmIjoxNTgzMjA0NzY5LCJleHAiOjE1ODM4MDk1NjksImRhdGEiOnsidXNlciI6eyJpZCI6IjExIn19fQ.0H4ZLd5etxnPySc9RoTJed21kd4SljY60PerN_rt2LA";
    final historyUrl = "$baseUrl/wp/v2/app/history/request";
    http.Response response = await http.get(
      historyUrl,
      headers: <String, String>{
        '${HttpHeaders.authorizationHeader}':'Bearer $testToken' ,
      },
    );
    return response;
  }
}
