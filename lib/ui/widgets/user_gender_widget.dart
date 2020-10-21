import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget userGender(gender) {
  switch (gender) {
    case 'm':
      return Icon(
        FontAwesomeIcons.mars,
        color: Colors.white,
      );
      break;
    case 'f':
      return Icon(
        FontAwesomeIcons.venus,
        color: Colors.white,
      );
      break;
    case 'b':
      return Icon(
        FontAwesomeIcons.transgender,
        color: Colors.white,
      );
      break;
    default:
      return null;
      break;
  }
}
