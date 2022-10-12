import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:camera/camera.dart';

import 'detection_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return _introScreen();
  }
}

Widget _introScreen() {
  return Stack(
    children: <Widget>[
      SplashScreen(
        seconds: 3,
        gradientBackground: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromRGBO(30, 144, 255, 0),
            Color.fromRGBO(30, 144, 255, 0)
          ],
        ),
        navigateAfterSeconds: HomePage([]),
        loaderColor: Colors.transparent,
      ),
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/logo.png"),
            fit: BoxFit.contain,
          ),
        ),
      ),
    ],
  );
}
