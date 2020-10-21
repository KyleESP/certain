import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
