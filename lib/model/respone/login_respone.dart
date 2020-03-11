class LoginRespone {
  String _token;
  String _userEmail;
  String _userNicename;
  String _userDisplayName;

  @override
  String toString() {
    return 'LoginRespone{_token: $_token, _userEmail: $_userEmail, _userNicename: $_userNicename, _userDisplayName: $_userDisplayName}';
  }

  LoginRespone(
      {String token,
        String userEmail,
        String userNicename,
        String userDisplayName}) {
    this._token = token;
    this._userEmail = userEmail;
    this._userNicename = userNicename;
    this._userDisplayName = userDisplayName;
  }

  String get token => _token;
  set token(String token) => _token = token;
  String get userEmail => _userEmail;
  set userEmail(String userEmail) => _userEmail = userEmail;
  String get userNicename => _userNicename;
  set userNicename(String userNicename) => _userNicename = userNicename;
  String get userDisplayName => _userDisplayName;
  set userDisplayName(String userDisplayName) =>
      _userDisplayName = userDisplayName;

  LoginRespone.fromJson(Map<String, dynamic> json) {
    _token = json['token'];
    _userEmail = json['user_email'];
    _userNicename = json['user_nicename'];
    _userDisplayName = json['user_display_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this._token;
    data['user_email'] = this._userEmail;
    data['user_nicename'] = this._userNicename;
    data['user_display_name'] = this._userDisplayName;
    return data;
  }
}