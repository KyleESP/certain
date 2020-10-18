import 'package:flutter/material.dart';
import 'package:certain/helpers/constants.dart';

Widget interestedInWidget(text, size, selected, onTap) {
  return Container(
    child: GestureDetector(
        onTap: onTap,
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                right: size * 0.02,
                left: size * 0.02,
                top: size * 0.04,
                bottom: size * 0.03),
            padding: EdgeInsets.all(size * 0.02),
            width: size * 0.25,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(40.0),
              gradient: selected == text ? gradient : gradientWhite,
              border: Border.all(
                  color:
                      selected == text ? Colors.transparent : Color(0xFFEB8C76),
                  width: 2.0),
              boxShadow: [
                BoxShadow(
                  color:
                      selected == text ? Colors.grey[300] : Colors.transparent,
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Text(
              interestedInGender(text),
              style: TextStyle(
                  color: selected == text ? Colors.white : Colors.grey[600],
                  fontSize: size * 0.04),
            ))),
  );
}

String interestedInGender(gender) {
  switch (gender) {
    case 'm':
      return "Homme";
      break;
    case 'f':
      return "Femme";
      break;
    case 'b':
      return "Les deux";
      break;
    default:
      return null;
      break;
  }
}
