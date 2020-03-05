import 'package:doraclaqua/model/user.dart';
import 'package:doraclaqua/provider/login_model.dart';
import 'package:doraclaqua/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginModel()),
      ],
      child: MaterialApp(
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => WelcomePage());
              break;
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginPage());
              break;
//            case '/home':
//              return MaterialPageRoute(builder: (_) => HomePage());
            default:
              return MaterialPageRoute(builder: (_) =>
                  Scaffold(
                    body: Center(
                        child: Text(
                            'No route defined for ${settings.name}')),
                  ));
          }
        },
        title: 'Flutter Demo',
        theme: ThemeData(),
//        home: WelcomePage(),
      ),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    LoginModel model = Provider.of<LoginModel>(context);
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
          _buildStartedWidget(model),
        ],
      ),
    );
  }

  Widget _buildStartedWidget(LoginModel loginModel) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 75),
            child: SizedBox(
              height: 50,
              width: 300,
              child: InkWell(
                onTap: () {
                  loginModel.signIn = true;
                  Navigator.pushNamed(context, '/login');
                },
                child: Card(
                  child: Center(
                    child: Text("Đăng nhập"),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: SizedBox(
              height: 50,
              width: 300,
              child: InkWell(
                onTap: () {
                  loginModel.signUp = true;
                  Navigator.pushNamed(context, '/login');
                },
                child: Card(
                    child: Center(
                      child: Text(
                        "Tạo tài khoản",
                      ),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
