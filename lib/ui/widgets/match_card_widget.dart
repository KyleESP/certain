import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:certain/helpers/constants.dart';

class MatchCard extends StatefulWidget {
  final String userName, userPhoto, selectedUserName, selectedUserPhoto;

  MatchCard(
      {Key key,
      this.userName,
      this.userPhoto,
      this.selectedUserName,
      this.selectedUserPhoto})
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
                    backgroundImage: NetworkImage(widget.userPhoto),
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
                    backgroundImage: NetworkImage(widget.selectedUserPhoto),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.0, 0.1),
                child: Text(
                  "Bravo ${widget.userName} !",
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
                  "Vous avez matché avec ${widget.selectedUserName} !",
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
