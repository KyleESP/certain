import 'package:certain/helpers/functions.dart';
import 'package:certain/ui/widgets/photo_browser_widget.dart';
import 'package:certain/ui/widgets/user_gender_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  final String name, bio, gender;
  final double distance;
  final Timestamp birthdate;
  final List<String> photos;

  ProfileCard(
      {Key key,
      this.name,
      this.birthdate,
      this.gender,
      this.bio,
      this.photos,
      this.distance})
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
    Size size = MediaQuery.of(context).size;

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
        padding: EdgeInsets.all(size.width * 0.05),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  Row(
                    children: <Widget>[
                      userGender(widget.gender),
                      Expanded(
                        child: Text(
                          "${widget.name}, ${calculateAge(widget.birthdate.toDate())}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.03),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      Text(
                        widget.distance != null
                            ? "${widget.distance} km"
                            : "Distance inconnue",
                        style: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.02),
                      )
                    ],
                  ),
                  if (widget.bio.isNotEmpty)
                    Container(
                      margin: EdgeInsets.all(size.height * 0.01),
                      child: Text(
                        '"' + widget.bio + '"',
                        style: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.018),
                      ),
                    ),
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
          BoxDecoration(borderRadius: BorderRadius.circular(20.0), boxShadow: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 10.0,
          spreadRadius: 2.0,
          offset: Offset(5.0, 5.0),
        )
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Material(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
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
