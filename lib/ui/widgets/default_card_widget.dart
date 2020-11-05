import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttery_dart2/layout.dart';

class DefaultCard extends StatefulWidget {
  final Widget card;

  DefaultCard({this.card});

  @override
  _DefaultCardState createState() => _DefaultCardState();
}

class _DefaultCardState extends State<DefaultCard>
    with TickerProviderStateMixin {
  Offset cardOffset = const Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: true,
      child: Center(),
      overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor) {
        return CenterAbout(
          position: anchor,
          child: Transform(
            transform:
                Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0),
            child: Container(
              width: anchorBounds.width * 1.1,
              height: anchorBounds.height * 1.1,
              padding: const EdgeInsets.all(16.0),
              child: widget.card,
            ),
          ),
        );
      },
    );
  }
}
