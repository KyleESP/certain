import 'package:certain/helpers/functions.dart';
import 'package:certain/ui/widgets/photo_browser_widget.dart';
import 'package:certain/ui/widgets/user_gender_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  final String name, bio, gender;
  final Timestamp birthdate;
  final List<String> photos;

  ProfileCard(
      {Key key, this.name, this.birthdate, this.gender, this.bio, this.photos})
      : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Widget _buildBackground() {
    return PhotoBrowser(
      photoAssetPaths: widget.photos,
      visiblePhotoIndex: 0,
    );
  }

  Widget _buildProfileSynopsis() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ])),
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  userGender(widget.gender),
                  Text(
                      "${widget.name}, ${calculateAge(widget.birthdate.toDate())}",
                      style: TextStyle(color: Colors.white, fontSize: 24.0)),
                  Text(widget.bio,
                      style: TextStyle(color: Colors.white, fontSize: 18.0))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
      BoxDecoration(borderRadius: BorderRadius.circular(10.0), boxShadow: [
        BoxShadow(
          color: const Color(0x11000000),
          blurRadius: 5.0,
          spreadRadius: 2.0,
        )
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Material(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildBackground(),
              _buildProfileSynopsis(),
            ],
          ),
        ),
      ),
    );
  }
}

