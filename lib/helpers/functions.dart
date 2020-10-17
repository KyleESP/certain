import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

scaffoldInfo(BuildContext context, String text, Widget sideWidget) {
  Scaffold.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(text), sideWidget],
        ),
      ),
    );
}
