import 'dart:async';

import 'package:certain/ui/pages/swap_card.dart';
import 'package:certain/ui/widgets/profile_card_widget.dart';
import 'package:flutter/material.dart';

import 'package:certain/models/user_model.dart';

class CardWidget extends StatefulWidget {
  final UserModel user;

  CardWidget(this.user);

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

    return DraggableCard(
      screenHeight: size.height,
      screenWidth: size.width,
      isDraggable: false,
      card: ProfileCard(
        name: widget.user.name,
        bio: widget.user.bio,
        gender: widget.user.gender,
        birthdate: widget.user.birthdate,
        photos: [widget.user.photo],
      ),
    );
  }
}
