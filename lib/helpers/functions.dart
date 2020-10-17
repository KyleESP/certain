import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

scaffoldLoading(BuildContext context, String text, Widget sideWidget) {
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
