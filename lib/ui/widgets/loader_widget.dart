import 'package:certain/helpers/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget loaderWidget() {
  return Center(
    child: CircularProgressIndicator(
      backgroundColor: loginButtonColor,
      valueColor: AlwaysStoppedAnimation<Color>(backgroundColorOrange),
    ),
  );
}
