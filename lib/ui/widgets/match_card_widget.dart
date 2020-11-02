import 'package:certain/helpers/functions.dart';
import 'package:certain/helpers/constants.dart';
import 'package:certain/ui/widgets/photo_browser_widget.dart';

import 'package:certain/ui/widgets/user_gender_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MatchCard extends StatefulWidget {
  final String user_name, user_photo, selectedUser_name, selectedUser_photo;

  MatchCard(
      {Key key,
      this.user_name,
      this.user_photo,
      this.selectedUser_name,
      this.selectedUser_photo})
      : super(key: key);

  @override
  _MatchCardState createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  Widget _buildBackground() {
    return Container(
      color: Colors.white,
    );
  }

  Widget _buildProfileSynopsis() {
    Size size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          height: size.height * 0.5,
          width: size.width * 0.9,
          padding: EdgeInsets.all(size.width * 0.02),
          decoration: BoxDecoration(
            gradient: gradient,
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment(0.7, -0.8),
                child: CircleAvatar(
                  radius: size.width * 0.18,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: size.width * 0.17,
                    backgroundImage: NetworkImage(widget.user_photo),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(-0.7, -0.8),
                child: CircleAvatar(
                  radius: size.width * 0.18,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: size.width * 0.17,
                    backgroundImage: NetworkImage(widget.selectedUser_photo),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment(0.0, 0.1),
                  child: Text(
                      "Bravo ${widget.user_name} !",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.035,
                    ),
                  ),
              ),
              Align(
                alignment: Alignment(0.0, 0.4),
                child: Text(
                  "Vous avez matché avec ${widget.selectedUser_name} !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.023,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          _buildBackground(),
          _buildProfileSynopsis(),
        ],
      ),
    );
  }
}
