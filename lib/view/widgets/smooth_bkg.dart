import 'package:flutter/material.dart';

class WaveBackground extends StatefulWidget {
  @override
  _WaveBackgroundState createState() => _WaveBackgroundState();

}

class _WaveBackgroundState extends State<WaveBackground> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child:  Container(height: 600 ,color: Colors.green,)/*Image.asset("assets/images/tree.jpg",alignment: Alignment.center,)*/,
      clipper: BottomWaveClipper(),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.quadraticBezierTo(size.width/5 * 4,size.height/4,size.width,0,);
    path.lineTo(0, size.height);
//    path.quadraticBezierTo(size.width/4 * 3,size.height,0,0,);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
