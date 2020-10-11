import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget loaderWidget() {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
    ),
  );
}
