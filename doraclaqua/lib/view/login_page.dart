import 'package:doraclaqua/provider/login_model.dart';
import 'package:doraclaqua/view/widgets/wave_animation/config.dart';
import 'package:doraclaqua/view/widgets/wave_animation/wave.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InheritedLogin extends InheritedWidget {
  InheritedLogin({Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  bool keyboardIsVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  dismissKeyBoard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static InheritedLogin of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedLogin>();
  }
}

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

  double bannerHeight = 250;

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
    LoginModel model = Provider.of<LoginModel>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(children: [
          _buildWaveAnimation(),
          Column(
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 100),
                height: InheritedLogin.of(context)
                        .keyboardIsVisible(context) /*&& model.signUp*/ ? 0
                    : 250,
                child: SizedBox(
                  height: bannerHeight,
                  child: Card(
                    elevation: 0,
                    child: Image.asset('assets/images/doiraclaqua.png'),
                  ),
                ),
              ),
//            !InheritedLogin.of(context).keyboardIsVisible(context)
//                ? SizedBox(
//                    height: bannerHeight,
//                    child: Card(
//                      elevation: 0,
//                      child: Image.asset('assets/images/doiraclaqua.png'),
//                    ),
//                  )
//                : Container(),
              AnimatedContainer(
                duration: Duration(milliseconds: 100),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 5 * 3.2,
                  child: Consumer<LoginModel>(builder: (context, model, child) {
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
                  }),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }

  Widget _buildWaveAnimation() {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [Colors.green[50], Color.fromRGBO(255, 255, 255, 0.1)],
          [Colors.green[200], Color.fromRGBO(255, 255, 255, 0.2)],
          [Colors.green, Color.fromRGBO(255, 255, 255, 0.4)],
          [Colors.green[700], Color.fromRGBO(255, 255, 255, 0.8)],
        ],
        durations: [35000, 19440, 10800, 6000],
        heightPercentages: [0.51, 0.52, 0.54, 0.55],
//        blur: MaskFilter.blur(BlurStyle.solid, 10),
        gradientBegin: Alignment.bottomLeft,
        gradientEnd: Alignment.topRight,
      ),
      waveAmplitude: 10,
      backgroundColor: Colors.white,
      size: Size(double.infinity, MediaQuery.of(context).size.height),
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
      builder: (BuildContext context, loginModel, Widget child) => Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Card(
          color: Color.fromRGBO(255, 255, 255, 0.95),
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
                                    InheritedLogin.of(context)
                                        .dismissKeyBoard(context);
                                    if (_signInFormKey.currentState
                                        .validate()) {
                                      bool isSuccess =
                                          await loginModel.excuteLoggedIn();
                                      _showMessage(context, isSuccess,
                                          messageFailed: loginModel.message,
                                          messageSuccess: loginModel.message);
                                      if (isSuccess) {
//                                          Navigator.pushNamed(context, "/home",arguments: loginModel.user);
                                        if (loginModel?.user?.token != null)
                                          _savePref(loginModel.user.token);
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            "/home",
                                            ModalRoute.withName('/'),
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
    );
  }

  _savePref(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
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
        builder: (context, loginModel, child) => Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Card(
                color: Color.fromRGBO(255, 255, 255, 0.95),
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: OutlineInputBorder(),
                                  icon: Icon(Icons.person_outline),
                                  hintText: "Họ và tên"),
                              onChanged: (value) {
                                loginModel.changeSignUpInfo(displayName: value);
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                        InheritedLogin.of(context)
                                            .dismissKeyBoard(context);
                                        if (_signUpFormKey.currentState
                                            .validate()) {
                                          bool isSuccess =
                                              await loginModel.createAccount();
                                          _showMessage(context, isSuccess,
                                              messageFailed: loginModel.message,
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
        builder: (context, loginModel, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: Color.fromRGBO(255, 255, 255, 0.95),
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
                                    InheritedLogin.of(context)
                                        .dismissKeyBoard(context);
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
