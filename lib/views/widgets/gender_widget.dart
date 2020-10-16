import 'package:flutter/material.dart';
import 'package:certain/helpers/constants.dart';

Widget genderWidget(icon, text, size, selected, onTap) {
  return Container(
    child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              right: size * 0.07,
              left: size * 0.07,
              top: size * 0.03,
              bottom: size * 0.03),
          padding: EdgeInsets.all(size * 0.05),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: selected == text ? gradient : gradientWhite,
            border: Border.all(
                color:
                    selected == text ? Colors.transparent : Color(0xFFEB8C76),
                width: 2.0),
            boxShadow: [
              BoxShadow(
                color: selected == text ? Colors.grey[300] : Colors.transparent,
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: text == selected ? Colors.white : Color(0xFFEB8C76),
            size: 30,
          ),
        )),
  );
}
