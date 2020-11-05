import 'package:certain/helpers/constants.dart';
import 'package:certain/ui/widgets/default_card_widget.dart';
import 'package:flutter/material.dart';

import 'package:certain/models/user_model.dart';

class MatchCardWidget extends StatefulWidget {
  final UserModel user;
  final UserModel selectedUser;

  MatchCardWidget({this.user, this.selectedUser});

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

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: DefaultCard(
        card: Material(
          child: Container(
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
                      backgroundImage: NetworkImage(widget.user.photo),
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
                      backgroundImage: NetworkImage(widget.selectedUser.photo),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0.0, 0.1),
                  child: Text(
                    "Bravo ${widget.user.name} !",
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
                    "Tu as matché avec ${widget.selectedUser.name} !",
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
      ),
    );
  }
}
