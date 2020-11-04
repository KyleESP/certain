import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

void scaffoldInfo(BuildContext context, String text, Widget sideWidget) {
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

Future<double> getDistance(GeoPoint userLocation) async {
  Position position =
      await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  double location = distanceBetween(userLocation.latitude,
          userLocation.longitude, position.latitude, position.longitude) /
      1000;

  location = double.parse(location.toStringAsFixed(2));

  return location;
}

int calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

String readTimestamp(DateTime date, bool displayHour) {
  Intl.defaultLocale = "fr";
  var now = DateTime.now();
  var formatDays = displayHour ? DateFormat('EEE HH:mm') : DateFormat('EEE');
  var format = DateFormat('HH:mm');
  var formatDate =
      displayHour ? DateFormat('d MMM, HH:mm') : DateFormat('d MMM');
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && now.day == date.day) {
    time = format.format(date);
  } else if (now.day != date.day && diff.inDays < 5) {
    time = formatDays.format(date);
  } else {
    time = formatDate.format(date);
  }
  return time;
}
