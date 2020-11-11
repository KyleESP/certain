import 'package:flutter/material.dart';

import 'package:certain/models/user_model.dart';

import 'package:certain/ui/widgets/default_card_widget.dart';

import 'package:certain/helpers/constants.dart';

class MatchCardWidget extends StatefulWidget {
  final UserModel user;
  final UserModel selectedUser;
  final Image userImage;
  final Image selectedUserImage;

  MatchCardWidget(
      {this.user, this.selectedUser, this.userImage, this.selectedUserImage});

  @override
  _MatchCardWidgetState createState() => _MatchCardWidgetState();
}

class _MatchCardWidgetState extends State<MatchCardWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultCard(
      card: Material(
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
          ),
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment(0.0, 0.0),
                  child: Container(
                    width: size.width * 0.8,
                    height: size.height * 0.48,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange[50],
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0.0, 5.0),
                        )
                      ],
                    ),
                    child: IconButton(
                      alignment: Alignment(0.95, -0.95),
                      icon: Icon(Icons.close),
                      color: Colors.black38,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )),
              Align(
                alignment: Alignment(0.5, -0.2),
                child: CircleAvatar(
                  radius: size.width * 0.18,
                  backgroundColor: backgroundColorRed,
                  child: ClipOval(
                    child: Container(
                      height: size.width * 0.34,
                      width: size.width * 0.34,
                      child: widget.userImage,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(-0.5, -0.2),
                child: CircleAvatar(
                  radius: size.width * 0.18,
                  backgroundColor: backgroundColorRed,
                  child: ClipOval(
                    child: Container(
                      height: size.width * 0.34,
                      width: size.width * 0.34,
                      child: widget.selectedUserImage,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.0, 0.15),
                child: Text(
                  "Bravo ${widget.user.name} !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: size.height * 0.035,
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.0, 0.25),
                child: Text(
                  "Tu as matché avec ${widget.selectedUser.name} !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
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
}
