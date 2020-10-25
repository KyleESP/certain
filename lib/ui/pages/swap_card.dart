import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttery_dart2/layout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:certain/ui/widgets/icon_widget.dart';
import 'package:certain/ui/widgets/profile_card_widget.dart';

import 'package:certain/models/user_model.dart';

import 'package:certain/helpers/constants.dart';

class SwapCard extends StatefulWidget {
  SwapCard({
    Key key,
    this.demoProfiles,
    this.size,
    this.myCallback,
  }) : super(key: key);

  final List<UserModel> demoProfiles;
  final Size size;

  final Function(Decision, UserModel user, bool lastReached) myCallback;

  @override
  _SwapCardState createState() => _SwapCardState();
}

class _SwapCardState extends State<SwapCard> {
  Match match = Match();

  @override
  Widget build(BuildContext context) {
    final MatchEngine matchEngine = MatchEngine(
        matches: widget.demoProfiles.map((UserModel user) {
      return Match(user: user);
    }).toList());

    return CardStack(
        matchEngine: matchEngine,
        onSwipeCallback: (match, user, lastReached) {
          widget.myCallback(match, user, lastReached);
        });

    /* Align(
          alignment: Alignment(0.0, 0.9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(widget.size.width * 0.01),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                ),
                child: iconWidget(Icons.clear, () {
                  matchEngine.currentMatch.nope();
                  widget.myCallback(
                      matchEngine.currentMatch.decision,
                      matchEngine.currentMatch.user,
                      matchEngine.nextMatch == null);
                  matchEngine.cycleMatch();
                }, widget.size.height * 0.07, dislikeButton),
              ),
              Container(
                padding: EdgeInsets.all(widget.size.width * 0.03),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                ),
                child: iconWidget(FontAwesomeIcons.solidHeart, () {
                  matchEngine.currentMatch.nope();
                  widget.myCallback(
                      matchEngine.currentMatch.decision,
                      matchEngine.currentMatch.user,
                      matchEngine.nextMatch == null);
                  matchEngine.cycleMatch();
                }, widget.size.height * 0.05, likeButton),
              ),
            ],
          ),
        )
     */
  }
}

class MatchEngine extends ChangeNotifier {
  final List<Match> _matches;
  int _currentMatchIndex;
  int _nextMatchIndex;

  MatchEngine({
    List<Match> matches,
  }) : _matches = matches {
    _currentMatchIndex = 0;
    _nextMatchIndex = 1;
  }

  Match get currentMatch => _matches[_currentMatchIndex];
  Match get nextMatch =>
      _nextMatchIndex < _matches.length ? _matches[_nextMatchIndex] : null;

  void cycleMatch() {
    if (currentMatch.decision != Decision.indecided) {
      currentMatch.reset();
      _currentMatchIndex = _nextMatchIndex;
      _nextMatchIndex++;
      notifyListeners();
    }
  }
}

class Match extends ChangeNotifier {
  final UserModel user;
  var decision = Decision.indecided;

  Match({this.user});

  void like() {
    //  if (decision == Decision.indecided) {
    decision = Decision.like;
    notifyListeners();
    // }
  }

  void nope() {
    // if (decision == Decision.indecided) {
    decision = Decision.nope;
    notifyListeners();
    //  }
  }

  void reset() {
    // if (decision != Decision.indecided) {
    decision = Decision.indecided;
    notifyListeners();
    // }
  }
}

enum Decision {
  indecided,
  nope,
  like,
}

class CardStack extends StatefulWidget {
  final Function(Decision, UserModel user, bool lastReached) onSwipeCallback;

  final MatchEngine matchEngine;

  CardStack({this.matchEngine, this.onSwipeCallback});

  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  Key _frontCard;
  Match _currentMatch;
  double _nextCardScale = 0.0;

  @override
  void initState() {
    super.initState();
    widget.matchEngine.addListener(_onMatchEngineChange);

    _currentMatch = widget.matchEngine.currentMatch;
    _currentMatch.addListener(_onMatchChange);

    _frontCard = Key(_currentMatch.user.name);
  }

  @override
  void didUpdateWidget(CardStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.matchEngine != oldWidget.matchEngine) {
      oldWidget.matchEngine.removeListener(_onMatchEngineChange);
      widget.matchEngine.addListener(_onMatchEngineChange);

      if (_currentMatch != null) {
        _currentMatch.removeListener(_onMatchChange);
      }

      _currentMatch = widget.matchEngine.currentMatch;
      if (_currentMatch != null) {
        _currentMatch.addListener(_onMatchChange);
      }
    }
  }

  @override
  void dispose() {
    if (_currentMatch != null) {
      _currentMatch.removeListener(_onMatchChange);
    }

    widget.matchEngine.removeListener(_onMatchEngineChange);
    super.dispose();
  }

  _onMatchEngineChange() {
    setState(() {
      if (_currentMatch != null) {
        _currentMatch.removeListener(_onMatchChange);
      }

      _currentMatch = widget.matchEngine.currentMatch;
      if (_currentMatch != null) {
        _currentMatch.addListener(_onMatchChange);
      }

      _frontCard = Key(_currentMatch.user.name);
    });
  }

  _onMatchChange() {
    setState(() {});
  }

  Widget _buildBackCard() {
    return Transform(
      transform: Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
      alignment: Alignment.center,
      child: ProfileCard(
          name: widget.matchEngine.nextMatch.user.name,
          gender: widget.matchEngine.nextMatch.user.gender,
          distance: widget.matchEngine.nextMatch.user.distance,
          birthdate: widget.matchEngine.nextMatch.user.birthdate,
          bio: widget.matchEngine.nextMatch.user.bio,
          photos: [widget.matchEngine.nextMatch.user.photo]),
    );
  }

  Widget _buildFrontCard() {
    return ProfileCard(
        key: _frontCard,
        name: widget.matchEngine.currentMatch.user.name,
        gender: widget.matchEngine.currentMatch.user.gender,
        distance: widget.matchEngine.currentMatch.user.distance,
        birthdate: widget.matchEngine.currentMatch.user.birthdate,
        bio: widget.matchEngine.currentMatch.user.bio,
        photos: [widget.matchEngine.currentMatch.user.photo]);
  }

  SlideDirection _desiredSlideOutDirection() {
    switch (widget.matchEngine.currentMatch.decision) {
      case Decision.nope:
        return SlideDirection.left;
        break;
      case Decision.like:
        return SlideDirection.right;
        break;
      default:
        return null;
    }
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  void _onSlideComplete(SlideDirection direction) {
    Match currentMatch = widget.matchEngine.currentMatch;

    switch (direction) {
      case SlideDirection.left:
        currentMatch.nope();
        widget.onSwipeCallback(currentMatch.decision, currentMatch.user,
            widget.matchEngine.nextMatch == null);
        break;
      case SlideDirection.right:
        currentMatch.like();
        widget.onSwipeCallback(currentMatch.decision, currentMatch.user,
            widget.matchEngine.nextMatch == null);
        break;
    }

    if (widget.matchEngine.nextMatch != null) {
      widget.matchEngine.cycleMatch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.matchEngine.nextMatch != null)
          DraggableCard(
            screenHeight: MediaQuery.of(context).size.height,
            screenWidth: MediaQuery.of(context).size.width,
            isDraggable: false,
            card: _buildBackCard(),
          ),
        DraggableCard(
          screenHeight: MediaQuery.of(context).size.height,
          screenWidth: MediaQuery.of(context).size.width,
          card: _buildFrontCard(),
          slideTo: _desiredSlideOutDirection(),
          onSlideUpdate: _onSlideUpdate,
          onSlideComplete: _onSlideComplete,
        )
      ],
    );
  }
}

enum SlideDirection {
  left,
  right,
}

class DraggableCard extends StatefulWidget {
  final Widget card;
  final bool isDraggable;
  final SlideDirection slideTo;
  final Function(double distance) onSlideUpdate;
  final Function(SlideDirection direction) onSlideComplete;
  final double screenWidth;
  final double screenHeight;

  DraggableCard({
    Key key,
    this.card,
    this.isDraggable = true,
    this.slideTo,
    this.onSlideUpdate,
    this.onSlideComplete,
    this.screenWidth,
    this.screenHeight,
  });

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  Decision decision;
  GlobalKey profileCardKey = GlobalKey(debugLabel: 'profile_card_key');
  Offset cardOffset = const Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPosition;
  Offset slideBackStart;
  SlideDirection slideOutDirection;
  AnimationController slideBackAnimation;
  Tween<Offset> slideOutTween;
  AnimationController slideOutAnimation;

  @override
  void initState() {
    super.initState();
    slideBackAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(slideBackStart, const Offset(0.0, 0.0),
                Curves.elasticOut.transform(slideBackAnimation.value));

            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate(cardOffset.distance);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
          });
        }
      });

    slideOutAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )
      ..addListener(() => setState(() {
            cardOffset = slideOutTween.evaluate(slideOutAnimation);

            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate(cardOffset.distance);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideOutTween = null;

            if (widget.onSlideComplete != null) {
              widget.onSlideComplete(slideOutDirection);
            }
          });
        }
      });
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.card.key != oldWidget.card.key) {
      cardOffset = const Offset(0.0, 0.0);
    }

    if (oldWidget.slideTo == null) {
      switch (widget.slideTo) {
        case SlideDirection.left:
          _slideLeft();
          break;
        case SlideDirection.right:
          _slideRight();
          break;
      }
    }
  }

  @override
  void dispose() {
    slideBackAnimation.dispose();
    slideOutAnimation.dispose();
    super.dispose();
  }

  void _slideLeft() {
    // final screenWidth = context.size.width;
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(-2 * widget.screenWidth, 0.0),
    );

    slideOutAnimation.forward(from: 0.0);
  }

  Offset _chooseRandomDragStart() {
    final cardContex = profileCardKey.currentContext;
    final cardTopLeft = (cardContex.findRenderObject() as RenderBox)
        .localToGlobal(const Offset(0.0, 0.0));
    final dragStartY =
        widget.screenHeight * (Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
            cardTopLeft.dy;

    return Offset(widget.screenWidth / 2 + cardTopLeft.dx, dragStartY);
  }

  void _slideRight() {
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(2 * widget.screenWidth, 0.0),
    );

    slideOutAnimation.forward(from: 0.0);
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;

    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop(canceled: true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition - dragStart;

      if (null != widget.onSlideUpdate) {
        widget.onSlideUpdate(cardOffset.distance);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset / cardOffset.distance;
    final isInLeftRegion = (cardOffset.dx / context.size.width) < -0.45;
    final isInRightRegion = (cardOffset.dx / context.size.width) > 0.45;

    setState(() {
      if (isInLeftRegion || isInRightRegion) {
        slideOutTween = Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.width));

        slideOutAnimation.forward(from: 0.0);

        slideOutDirection =
            isInLeftRegion ? SlideDirection.left : SlideDirection.right;
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0.0);
      }
    });
  }

  double _rotation(Rect dragBounds) {
    if (dragStart != null) {
      final rotationCornerMultiplier =
          dragStart.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (pi / 8) *
          (cardOffset.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (dragStart != null) {
      return dragStart - dragBounds.topLeft;
    } else {
      return const Offset(0.0, 0.0);
    }
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
                Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
                  ..rotateZ(_rotation(anchorBounds)),
            origin: _rotationOrigin(anchorBounds),
            child: Container(
              key: profileCardKey,
              width: anchorBounds.width,
              height: anchorBounds.height,
              padding: const EdgeInsets.all(16.0),
              child: widget.isDraggable
                  ? GestureDetector(
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      child: widget.card,
                    )
                  : widget.card,
            ),
          ),
        );
      },
    );
  }
}
