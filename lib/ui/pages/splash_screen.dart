import 'package:flutter/material.dart';

import 'package:certain/helpers/constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        width: size.width,
        height: size.height,
        child: Center(
          child: Image.asset('assets/images/logo.png',
              height: size.width * 0.6, width: size.width * 0.6),
        ),
      ),
    );
  }
}
