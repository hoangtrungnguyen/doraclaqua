import 'package:doraclaqua/provider/login_model.dart';
import 'package:doraclaqua/view/home_page.dart';
import 'package:doraclaqua/view/login_page.dart';
import 'package:doraclaqua/view/request_page.dart';
import 'package:doraclaqua/view/widgets/theme.dart';
import 'package:doraclaqua/view/widgets/wave_animation/config.dart';
import 'package:doraclaqua/view/widgets/wave_animation/wave.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/user.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
//        initialRoute: token.isEmpty ? null : "/home",
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => WelcomePage());
            break;
          case '/login':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => InheritedLogin(
                      child: LoginPage(initialPage: settings.arguments,),
                    ),
                transitionDuration: Duration(milliseconds: 400),
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
            return PageRouteBuilder<bool>(
                pageBuilder: (_, animation, __) {

                  return RequestForm();
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
      theme: lightTheme(context),
//        home: WelcomePage(),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Stack(children: <Widget>[
//        LinearProgressIndicator()
//        Image.asset("assets/images/tree.jpg"),
        Positioned(
            child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: _buildWaveAnimation(),
        )),
//        Container(color: Colors.green,),
        Column(
          children: <Widget>[
            Container(
              height: 100,
            ),
            SizedBox(
              height: 200,
              child: Card(
                elevation: 4,
                child: Image.asset('assets/images/doiraclaqua.png'),
              ),
            ),
            _buildStartedWidget(),
          ],
        ),
      ]),
    );
  }

  Widget _buildStartedWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 75),
            child: SizedBox(
              height: 50,
              width: 300,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: Colors.green[50],
                elevation: 4.0,
                onPressed: ()async {
                  Navigator.pushNamed(context, '/login',arguments: 0);

                },
                child: Center(
                  child: Text("Đăng nhập"),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),

            child: SizedBox(
              height: 50,
              width: 300,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Colors.green[50],
                  elevation: 4.0,
                  onPressed: () async {
                    Navigator.pushNamed(context, '/login',arguments: 1);
                  },
                  child: Center(
                    child: Text(
                      "Tạo tài khoản",
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWaveAnimation() {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            Color.fromRGBO(255, 255, 255, 0.1),
            Color.fromRGBO(255, 255, 255, 0.1)
          ],
          [
            Color.fromRGBO(255, 255, 255, 0.4),
            Color.fromRGBO(255, 255, 255, 0.2)
          ],
          [
            Color.fromRGBO(255, 255, 255, 0.7),
            Color.fromRGBO(255, 255, 255, 0.4)
          ],
          [
            Color.fromRGBO(255, 255, 255, 0.9),
            Color.fromRGBO(255, 255, 255, 0.8)
          ],
        ],
        durations: [35000, 19440, 10800, 6000],
        heightPercentages: [0.71 - 0.1, 0.72 - 0.1, 0.74 - 0.1, 0.75 - 0.1],
//        blur: MaskFilter.blur(BlurStyle.solid, 10),
        gradientBegin: Alignment.bottomLeft,
        gradientEnd: Alignment.topRight,
      ),
      waveAmplitude: 10,
      backgroundColor: Colors.green,
      size: Size(double.infinity, MediaQuery.of(context).size.height),
    );
  }
}
