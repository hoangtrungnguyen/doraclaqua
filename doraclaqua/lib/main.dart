import 'package:doraclaqua/provider/login_model.dart';
import 'package:doraclaqua/view/home_page.dart';
import 'package:doraclaqua/view/login_page.dart';
import 'package:doraclaqua/view/request_page.dart';
import 'package:doraclaqua/view/widgets/smooth_bkg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/user.dart';

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
              return PageRouteBuilder(
                  pageBuilder: (_, __, ___) => LoginPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var tween = Tween(begin: begin, end: end);
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  });
              break;
            case '/home':
              return PageRouteBuilder(
                  pageBuilder: (_, animation, __) {
                    User user = settings.arguments;
                    return HomePage(user);
                  },
                  transitionDuration: Duration(milliseconds: 300),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var tween = Tween(begin: begin, end: end);

                    var curve = Curves.fastOutSlowIn;

                    var curvedAnimation = CurvedAnimation(
                      parent: animation,
                      curve: curve,
                    );

                    return SlideTransition(
                      position: tween.animate(curvedAnimation),
                      child: child,
                    );
                  });
            case '/request':
              return PageRouteBuilder(
                  pageBuilder: (_, animation, __) {
                    User user = settings.arguments;
                    return RequestForm(user);
                  },
                  transitionDuration: Duration(milliseconds: 300),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var tween = Tween(begin: begin, end: end);

                    var curve = Curves.fastOutSlowIn;

                    var curvedAnimation = CurvedAnimation(
                      parent: animation,
                      curve: curve,
                    );

                    return SlideTransition(
                      position: tween.animate(curvedAnimation),
                      child: child,
                    );
                  });
            default:
              return MaterialPageRoute(
                  builder: (_) => Scaffold(
                        body: Center(
                            child:
                                Text('No route defined for ${settings.name}')),
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
      body: Stack(children: <Widget>[
        Positioned(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: WaveBackground())),
//        Container(color: Colors.green,),
        Column(
          children: <Widget>[
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
      ]),
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
