import 'package:certain/blocs/matches/bloc.dart';
import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/matches_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:certain/models/question_model.dart';

import 'package:certain/ui/widgets/play_qcm_widgets.dart';

import 'package:certain/helpers/constants.dart';

import 'messages.dart';

class PlayMcq extends StatefulWidget {
  final UserModel user;
  final UserModel selectedUser;

  PlayMcq({this.user, this.selectedUser});

  @override
  _PlayMcqState createState() => _PlayMcqState();
}

class _PlayMcqState extends State<PlayMcq> {
  final MatchesRepository _matchesRepository = MatchesRepository();
  MatchesBloc _matchesBloc;
  List<QuestionModel> _mcq;
  String _optionSelected;
  QuestionModel _questionSelected;
  int _correct = 0;
  int _mcqSize;
  List<String> _optionsShuffled = [];

  bool get isLastQuestion => _mcq.length == 1;

  bool get isButtonEnabled =>
      _questionSelected != null && _optionSelected != null;

  @override
  void initState() {
    _mcq = widget.selectedUser.mcq;
    _mcqSize = _mcq.length;
    _questionSelected = _mcq[0];
    _optionsShuffled = [
      _questionSelected.option1,
      _questionSelected.option2,
      _questionSelected.option3
    ]..shuffle();
    _matchesBloc = MatchesBloc(_matchesRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              autovalidate: true,
              child: ListView(
                padding: EdgeInsets.all(4),
                children: <Widget>[
                  Text(_questionSelected.question),
                  SizedBox(
                    height: 12,
                  ),
                  optionWidget(_optionsShuffled[0], "A"),
                  optionWidget(_optionsShuffled[1], "B"),
                  optionWidget(_optionsShuffled[2], "C"),
                  Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_optionSelected == _questionSelected.option1) {
                            _correct++;
                          }
                          if (isLastQuestion) {
                            var successPercentage = _correct / _mcqSize;
                            if (successPercentage >= 0.5) {
                              _matchesBloc.add(
                                OpenChatEvent(
                                    currentUser: widget.user.uid,
                                    selectedUser: widget.selectedUser.uid),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Messages(
                                      userId: widget.user.uid,
                                    );
                                  },
                                ),
                              );
                            } else {
                              _matchesBloc.add(
                                RemoveMatchEvent(
                                    currentUser: widget.user.uid,
                                    selectedUser: widget.selectedUser.uid),
                              );
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Tabs(widget.user.uid);
                                  },
                                ),
                              );*/
                            }
                          }
                          setState(() {
                            _mcq.remove(_questionSelected);
                            _questionSelected = _mcq[0];
                            _optionSelected = null;
                            _optionsShuffled = [
                              _questionSelected.option1,
                              _questionSelected.option2,
                              _questionSelected.option3
                            ]..shuffle();
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 2 - 40,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          decoration: BoxDecoration(
                              color: isButtonEnabled
                                  ? loginButtonColor
                                  : loginButtonColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            !isLastQuestion ? "Prochaine question" : "Terminer",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }

  Widget optionWidget(String option, label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _optionSelected = option;
        });
      },
      child: OptionTile(
        option: label,
        description: "$option",
        optionSelected: _optionSelected,
        correctAnswer: _optionSelected,
      ),
    );
  }
}
