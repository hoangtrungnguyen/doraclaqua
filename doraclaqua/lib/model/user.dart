
class User {

  String _userName;
  String _password;
  String _userDisplayName;
  String _userEmail;
  String _token;


  User.name(this._userName, this._password, this._userDisplayName,
      this._userEmail, this._token);


  User();

  String get token => _token;

  set token(String value) {
    _token = value;
  }

  String get userEmail => _userEmail;

  set userEmail(String value) {
    _userEmail = value;
  }

  String get userDisplayName => _userDisplayName;

  set userDisplayName(String value) {
    _userDisplayName = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  @override
  String toString() {
    return 'User{_userName: $_userName, _password: $_password, _userDisplayName: $_userDisplayName, _userEmail: $_userEmail}';
  }


}

