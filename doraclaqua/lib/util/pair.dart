import 'package:flutter/cupertino.dart';

class Pair <F,S>{
  F first;
  S second;

  Pair({@required this.first,@required this.second});

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }


}