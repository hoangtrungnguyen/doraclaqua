

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme(BuildContext context) {
  Theme.of(context).copyWith(
          primaryColor: Colors.green,
          accentColor: Colors.blueAccent.shade400,
          primaryColorBrightness: Brightness.dark,
          cardColor: Colors.green.shade100,
//          textTheme: Theme.of(context)
//              .textTheme
//              .copyWith(subtitle1: TextStyle(fontFamily: "Baloon2"))
              );

}
final cupertinoLightTheme = CupertinoThemeData(
);
