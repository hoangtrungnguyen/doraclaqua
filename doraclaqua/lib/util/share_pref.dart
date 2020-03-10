import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const userToken = "user_token";

class SharePre {


  static savePref(String token) async {
     SharedPreferences.getInstance().then((prefs){
       prefs.setString(userToken, token);
     });
  }

  static Future<void> deleteToken() async {
    SharedPreferences.getInstance().then((prefs){
      prefs.setString(userToken, "null");
    });

  }


  static  Future<String> getStringValue({@required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key);
    return value;
  }

  static Future<dynamic> getValue({@required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.get(key);
  }

}