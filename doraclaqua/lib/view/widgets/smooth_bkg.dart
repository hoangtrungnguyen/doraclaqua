import 'package:flutter/material.dart';

class WaveBackground extends StatefulWidget {
  @override
  _WaveBackgroundState createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child:  Container(height: 400 ,color: Colors.green,)/*Image.asset("assets/images/tree.jpg",alignment: Alignment.center,)*/,
      clipper: BottomWaveClipper(),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

// Since the wave goes vertically lower than bottom left starting point,
// we'll have to make this point a little higher.
    path.lineTo(0.0, size.height);
    path.quadraticBezierTo(size.width/2,size.height, size.width,size.height - 100);

// TODO: The wavy clipping magic happens here, between the bottom left and bottom right points.

// The bottom right point also isn't at the same level as its left counterpart,
// so we'll adjust that one too.
//    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
