class LoginData {
  String _username;
  String _password;

  LoginData({String username, String password}) {
    this._username = username;
    this._password = password;
  }

  String get username => _username;
  set username(String username) => _username = username;
  String get password => _password;
  set password(String password) => _password = password;

  LoginData.fromJson(Map<String, dynamic> json) {
    _username = json['username'];
    _password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this._username;
    data['password'] = this._password;
    return data;
  }
}