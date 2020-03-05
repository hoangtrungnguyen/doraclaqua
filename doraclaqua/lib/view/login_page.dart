import 'dart:math';

import 'package:doraclaqua/provider/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController _animController;
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..forward();
    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(_animController);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Text("ASS"),
          Container(
            height: 100,
          ),
          SizedBox(
            height: 200,
            child: Card(
              elevation: 0,
              child: Image.asset('assets/images/doiraclaqua.png'),
            ),
          ),
          Consumer<LoginModel>(builder: (context, model, child) {
            final animation =
                Tween<Offset>(begin: Offset(0, 0), end: Offset(1, 1))
                    .animate(_animController);
            if (model.signUp) {
              return _SignUpForm();
            } else if (model.signIn) {
              return SignInForm();
            } else {
              return ForgotPasswordForm();
            }
          })
        ],
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    LoginModel model = Provider.of<LoginModel>(context);
    return Consumer<LoginModel>(
      builder: (BuildContext context, loginModel, Widget child) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Card(
            child: Form(
                key: _signInFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 16.0,
                      ),
                      Text("Đăng nhập",
                          style: Theme.of(context).textTheme.headline5),
                      Spacer(
                        flex: 2,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(gapPadding: 10.0),
                            contentPadding: EdgeInsets.all(10.0),
                            icon: Icon(Icons.person),
                            hintText: "Tên đăng nhập"),
                        onChanged: (value) {
                          model.changeLoginInfo(name: value);
                        },
                        initialValue: loginModel.loginData.username,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Bạn phải điền tên đăng nhập";
                          }
                          return null;
                        },
                      ),
                      Spacer(),
                      TextFormField(
                        initialValue: loginModel.loginData.password,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(gapPadding: 10.0),
                            contentPadding: EdgeInsets.all(10.0),
                            icon: Icon(Icons.lock),
                            hintText: "Mật khẩu"),
                        onChanged: (value) {
                          model.changeLoginInfo(password: value);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Bạn chưa nhập mật khẩu";
                          }
                          return null;
                        },
                      ),
                      Spacer(flex: 3),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: loginModel.isLoading
                            ? CircularProgressIndicator()
                            : ButtonTheme(
                                minWidth: 200,
                                height: 50,
                                child: RaisedButton(
                                    color: Colors.white,
                                    elevation: 3.0,
                                    onPressed: () async {
                                      if (_signInFormKey.currentState
                                          .validate()) {
                                        bool isSuccess =
                                            await loginModel.excuteLoggedIn();
                                        _showMessage(context, isSuccess,
                                            messageFailed: loginModel.message,
                                            messageSuccess: loginModel.message);
                                        if (true) {
//                                          Navigator.pushNamed(context, "/home",arguments: loginModel.user);
                                          Navigator.pushNamedAndRemoveUntil(context, "/home",ModalRoute.withName('/'),
                                              arguments: loginModel.user);

                                        }
                                      }
                                    },
                                    child: Center(
                                        child: Text(
                                      "Đăng nhập",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ))),
                              ),
                      ),
                      Spacer(
                        flex: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              loginModel.signUp = true;
                            },
                            child: SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(
                                  "Tạo tài khoản mới",
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              loginModel.forgotPass = true;
                            },
                            child: SizedBox(
                                height: 50,
                                child: Center(child: Text("Quên mật khẩu"))),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<_SignUpForm> {
  final _signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginModel>(
        builder: (context, loginModel, child) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Card(
                  child: Form(
                      key: _signUpFormKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 16.0,
                            ),
                            Text(
                              "Tạo mới tài khoản",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Spacer(
                              flex: 3,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.person_outline),
                                    hintText: "Họ và tên"),
                                onChanged: (value) {
                                  loginModel.changeSignUpInfo(
                                      displayName: value);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Bạn phài điển họ và tên";
                                  }
                                  if (value.length < 6) {
                                    return "Họ và tên quá ngắn";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.email),
                                    hintText: "E-mail"),
                                onChanged: (value) {
                                  loginModel.changeSignUpInfo(email: value);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Bạn phải điền địa chỉ email";
                                  }
                                  if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    return "Địa chỉ e-mail của bạn không hợp lệ";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.person_pin),
                                    hintText: "Tên đăng nhập"),
                                onChanged: (value) {
                                  loginModel.changeSignUpInfo(userName: value);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Bạn phải điền tên đăng nhập";
                                  }
                                  if (value.length < 6) {
                                    return "Tên của bạn quá ngắn";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                obscureText: true,
                                maxLength: 24,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.lock),
                                    hintText: "Mật khẩu"),
                                onChanged: (value) {
                                  loginModel.changeSignUpInfo(password: value);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Bạn phải điền mật khẩu";
                                  }
                                  if (value.length < 6) {
                                    return "Mật khẩu của bạn quá ngắn";
                                  }
                                  if (!RegExp(".*[0-9].*").hasMatch(value)) {
                                    return "Mật khẩu cần có ít nhất 1 chữ sỗ";
                                  }
                                  if (!RegExp(".*[a-z].*").hasMatch(value)) {
                                    return "Mật khẩu cần có ít nhất 1 chữ cái thường";
                                  }
                                  if (!RegExp(".*[A-Z].*").hasMatch(value)) {
                                    return "Mật khẩu cần có ít nhất 1 chữ cái hoa";
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: ButtonTheme(
                                minWidth: 200,
                                height: 50,
                                child: loginModel.isLoading
                                    ? CircularProgressIndicator()
                                    : RaisedButton(
                                        color: Colors.white,
                                        elevation: 3.0,
                                        onPressed: () async {
                                          if (_signUpFormKey.currentState
                                              .validate()) {
                                            bool isSuccess = await loginModel
                                                .createAccount();
                                            _showMessage(context, isSuccess,
                                                messageFailed:
                                                    loginModel.message,
                                                messageSuccess:
                                                    loginModel.message);
                                          }
                                        },
                                        child: Center(
                                            child: Text(
                                          "Tạo tài khoản",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ))),
                              ),
                            ),
                            Spacer(
                              flex: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    loginModel.signIn = true;
                                  },
                                  child: SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        "Đăng nhập",
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    loginModel.forgotPass = true;
                                  },
                                  child: SizedBox(
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                        "Quên mật khẩu",
                                        textAlign: TextAlign.center,
                                      ))),
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ));
  }
}

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginModel>(
        builder: (context, loginModel, child) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: Form(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 16.0,
                        ),
                        Text(
                          "Lấy mật khẩu mới",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Spacer(),
                        TextFormField(
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(),
                              icon: Icon(Icons.email),
                              hintText: "E-mail"),
                          initialValue: loginModel.newPassRequestName,
                          onChanged: (value) {
                            loginModel.newPassRequestName = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Bạn phải điền tên";
                            }
                            return null;
                          },
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: ButtonTheme(
                            minWidth: 200,
                            height: 50,
                            child: loginModel.isLoading
                                ? CircularProgressIndicator()
                                : RaisedButton(
                                    color: Colors.white,
                                    elevation: 3.0,
                                    onPressed: () async {
                                      bool isSuccess =
                                          await loginModel.requestNewPass();
                                      _showMessage(context, isSuccess,
                                          messageFailed: loginModel.message,
                                          messageSuccess: loginModel.message);
                                    },
                                    child: Center(
                                        child: Text(
                                      "Lấy mật khẩu mới",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ))),
                          ),
                        ),
                        Spacer(
                          flex: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                loginModel.signUp = false;
                              },
                              child: SizedBox(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    "Tạo tài khoản mới",
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                loginModel.signIn = true;
                              },
                              child: SizedBox(
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    "Đăng nhập",
                                    textAlign: TextAlign.center,
                                  ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                ),
              ),
            ));
  }
}

void _showMessage(BuildContext context, bool isSuccess,
    {String messageSuccess, String messageFailed}) {
  if (isSuccess) {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
        content: Container(height: 50, child: Html(data: messageSuccess))));
  } else {
    Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Container(height: 50, child: Html(data: "${messageFailed}"))));
  }
}
