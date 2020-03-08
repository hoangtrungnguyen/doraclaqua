import 'dart:convert';

import 'package:doraclaqua/model/login_data.dart';
import 'package:doraclaqua/model/respone/error_respone.dart';
import 'package:doraclaqua/model/respone/login_respone.dart';
import 'package:doraclaqua/model/user.dart';
import 'package:doraclaqua/repository/respository.dart' as AppClient;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginModel extends ChangeNotifier {
  LoginModel();

  bool _signIn = false;

  bool _signUp = false;

  bool _forgotPass = false;

  String _message;

  bool _isLoading = false;

  User _user = User();

  String _newPassRequestName = "";

  String get newPassRequestName => _newPassRequestName;

  set newPassRequestName(String value) {
    _newPassRequestName = value;
    notifyListeners();
  }

  get signIn => _signIn;

  set signIn(bool signIn) {
    _signIn = signIn;
    _forgotPass = !signIn;
    _signUp = !signIn;
    notifyListeners();
  }

  get signUp => _signUp;

  set signUp(bool signUp) {
    _signUp = signUp;
    _signIn = !signUp;
    _forgotPass = !signUp;
    notifyListeners();
  }

  get forgotPass => _forgotPass;

  set forgotPass(bool forgotPass) {
    _forgotPass = forgotPass;
    _signIn = !forgotPass;
    _signUp = !forgotPass;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String get message => _message;

  set message(String value) {
    _message = value;
    notifyListeners();
  }

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  LoginData _loginData = LoginData(username: "tomtom",password: "12345Aa");

  LoginData get loginData => _loginData;

  set loginData(LoginData value) {
    _loginData = value;
  }

  void changeLoginInfo({String name, String password}) {
    if (name != null) _loginData.username = name;
    if (password != null) _loginData.password = password;
  }

  void changeSignUpInfo(
      {String userName,
      String displayName,
      String password,
      String email,
      String phoneNumber}) {
    if (userName != null) _user.userName = userName;
    if (displayName != null) _user.userDisplayName = displayName;
    if (password != null) _user.password = password;
    if (email != null) _user.userEmail = email;
    print("user $user");
  }

  Future<bool> excuteLoggedIn() async {
    isLoading = true;
    try {
      bool connectedInternet = await AppClient.Client.checkInternet();
      if (!connectedInternet) {
        _message = "Please connect to the Internet";
        return false;
      }
      Response response = await AppClient.Client.authentication(loginData);
      if (response.statusCode == 200) {
        LoginRespone loginResponse =
            LoginRespone.fromJson(json.decode(response.body));
        user = User.name(
            loginResponse.userNicename,
            loginData.password,
            loginResponse.userDisplayName,
            loginResponse.userEmail,
            loginResponse.token);
        print("user after excute success $user");//TODO check lại phần này
        message = "Tạo tài khoản mới thành công";
        return true;
      }

      ErrorResponse errorResponse =
          ErrorResponse.fromJson(json.decode(response.body));
      message = errorResponse.message;
      return false;
    } on Exception catch (e) {
      message = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> createAccount() async {
    isLoading = true;
    try {
      Response response = await AppClient.Client.registerNewUser(user)
          .timeout(Duration(seconds: 30));
      if (response.statusCode == 200) {
        message = "Tạo tài khoản thành công";
        signIn = true;
        return true;
      }

      ErrorResponse errorResponse =
          ErrorResponse.fromJson(json.decode(response.body));
      message = "${errorResponse.message}";
      return false;
    } on Exception catch (e) {
      message = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> requestNewPass() async{
    isLoading = true;
    try {
      Response response = await AppClient.Client.requestNewPass(newPassRequestName).timeout(Duration(seconds: 45));
      if(response.statusCode == 200){
        message = "Yêu cầu mật khẩu mới thành công";
        return true;
      }

      ErrorResponse errorResponse = ErrorResponse.fromJson(json.decode(response.body));
      message = errorResponse.message;
      return false;
    } on Exception catch (e) {
      message = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  void _checkPermissions() async {
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (status != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    }
  }
}
