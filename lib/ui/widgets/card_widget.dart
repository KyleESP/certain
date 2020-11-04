import 'dart:async';

import 'package:certain/ui/pages/swap_card.dart';
import 'package:certain/ui/widgets/match_card_widget.dart';
import 'package:certain/ui/widgets/profile_card_widget.dart';
import 'package:flutter/material.dart';

import 'package:certain/models/user_model.dart';

class CardWidget extends StatefulWidget {
  final UserModel user;
  final UserModel selectedUser;

  CardWidget(this.user, this.selectedUser);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () => Navigator.pop(context));
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: DraggableCard(
        screenHeight: size.height,
        screenWidth: size.width,
        isDraggable: false,
        card: MatchCard(
          user_name: widget.user.name,
          user_photo: widget.user.photo,
          selectedUser_name: widget.selectedUser.name,
          selectedUser_photo: widget.selectedUser.photo,
        ),
      ),
    );
  }
}
