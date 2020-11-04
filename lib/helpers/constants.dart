import 'package:flutter/material.dart';

Color backgroundColorRed = Colors.red[300];
Color backgroundColorOrange = Colors.deepOrangeAccent[100];
Color backgroundColorYellow = Colors.amber[200];
const Color loginButtonColor = Color(0xFFE04A5A);
LinearGradient gradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.3, 0.6, 1.0],
    colors: [backgroundColorRed, backgroundColorOrange, backgroundColorYellow]);
LinearGradient gradientWhite = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [0.3, 0.6, 1.0],
    colors: [Colors.white, Colors.white, Colors.white]);
const Color likeButton = Color(0xFF8DDACA);
const Color dislikeButton = Color(0xFFE04A5A);
const Color logoutButton = Color(0xFFEE9189);
