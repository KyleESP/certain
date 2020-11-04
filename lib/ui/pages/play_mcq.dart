import 'package:certain/blocs/play_mcq/play_mcq_bloc.dart';
import 'package:certain/blocs/play_mcq/play_mcq_event.dart';
import 'package:certain/blocs/play_mcq/play_mcq_state.dart';
import 'package:certain/ui/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:certain/models/question_model.dart';
import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/matches_repository.dart';

import 'package:certain/ui/widgets/play_qcm_widgets.dart';

import 'package:certain/helpers/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayMcq extends StatelessWidget {
  final _matchesRepository = new MatchesRepository();
  final UserModel user;
  final UserModel selectedUser;

  PlayMcq({@required this.user, @required this.selectedUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<PlayMcqBloc>(
        create: (context) => PlayMcqBloc(_matchesRepository),
        child: PlayMcqForm(user: user, selectedUser: selectedUser),
      ),
    );
  }
}

class PlayMcqForm extends StatefulWidget {
  final UserModel user;
  final UserModel selectedUser;

  PlayMcqForm({this.user, this.selectedUser});

  @override
  _PlayMcqFormState createState() => _PlayMcqFormState();
}

class _PlayMcqFormState extends State<PlayMcqForm> {
  PlayMcqBloc _playMcqBloc;
  List<QuestionModel> _mcq;
  String _optionSelected;
  QuestionModel _questionSelected;
  int _correct = 0;
  List<String> _optionsShuffled = [];

  bool get isLastQuestion => _mcq.length == 1;

  bool get isButtonEnabled =>
      _questionSelected != null && _optionSelected != null;

  @override
  void initState() {
    _playMcqBloc = BlocProvider.of<PlayMcqBloc>(context);
    _mcq = widget.selectedUser.mcq;
    _questionSelected = _mcq[0];
    _optionsShuffled = [
      _questionSelected.option1,
      _questionSelected.option2,
      _questionSelected.option3
    ]..shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    Size size = MediaQuery.of(context).size;
    return BlocListener<PlayMcqBloc, PlayMcqState>(listener: (context, state) {
      if (state is CompletedState) {
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              });
              return SimpleDialog(
                backgroundColor: Colors.transparent,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            height: size.height * 0.5,
                            width: size.width * 0.9,
                            padding: EdgeInsets.all(size.width * 0.02),
                            decoration: BoxDecoration(
                              gradient: gradient,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.05,
                        right: size.width * 0.06,
                        child: CircleAvatar(
                          radius: size.width * 0.18,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: size.width * 0.17,
                            backgroundImage: NetworkImage(widget.user.photo),
                          ),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.05,
                        left: size.width * 0.06,
                        child: CircleAvatar(
                          radius: size.width * 0.18,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: size.width * 0.17,
                            backgroundImage:
                                NetworkImage(widget.selectedUser.photo),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: size.height * 0.15),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.023,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            });
      }
    }, child: BlocBuilder<PlayMcqBloc, PlayMcqState>(builder: (context, state) {
      if (state is LoadingState) {
        return loaderWidget();
      }
      return Scaffold(
          body: Container(
              decoration: BoxDecoration(
                gradient: gradient,
              ),
              width: size.width,
              height: size.height,
              padding: const EdgeInsets.all(25),
              child: Stack(alignment: Alignment.center, children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: size.height * 0.05,
                      left: size.width * 0.03,
                      right: size.width * 0.03),
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Répondez au questionnaire de ${widget.selectedUser.name}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontSize: size.height * 0.028),
                  ),
                ),
                Container(
                  height: size.height * 0.46,
                  width: size.width * 0.82,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[800],
                        blurRadius: 20.0,
                        spreadRadius: 10.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                        height: size.height * 0.5,
                        width: size.width * 0.95,
                        padding: EdgeInsets.all(size.width * 0.05),
                        color: Colors.white,
                        child: Form(
                          key: _formKey,
                          autovalidate: true,
                          child: ListView(
                            padding: EdgeInsets.all(4),
                            children: <Widget>[
                              Text(
                                "Question ${7 - _mcq.length}/6",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: size.height * 0.018,
                                    color: Colors.black54),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Text(
                                _questionSelected.question,
                                style: TextStyle(
                                    fontSize: size.height * 0.018,
                                    color: Colors.black87),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              optionWidget(_optionsShuffled[0], "A"),
                              optionWidget(_optionsShuffled[1], "B"),
                              optionWidget(_optionsShuffled[2], "C"),
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  onTap: () {
                                    if (isLastQuestion) {
                                      var successPercentage = _correct / 6;
                                      _playMcqBloc.add(CompletedEvent(
                                          currentUserId: widget.user.uid,
                                          selectedUserId:
                                              widget.selectedUser.uid,
                                          status: successPercentage >= 0.5
                                              ? "s"
                                              : "f"));
                                    } else if (isButtonEnabled) {
                                      setState(() {
                                        if (_optionSelected ==
                                            _questionSelected.option1) {
                                          _correct++;
                                        }
                                        _mcq.remove(_questionSelected);
                                        _questionSelected = _mcq[0];
                                        _optionSelected = null;
                                        _optionsShuffled = [
                                          _questionSelected.option1,
                                          _questionSelected.option2,
                                          _questionSelected.option3
                                        ]..shuffle();
                                      });
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        left: size.width * 0.05,
                                        right: size.width * 0.05),
                                    width: size.width * 0.4,
                                    height: size.height * 0.08,
                                    decoration: BoxDecoration(
                                      color: isButtonEnabled
                                          ? loginButtonColor
                                          : loginButtonColor.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      !isLastQuestion
                                          ? "Question suivante"
                                          : "Terminer",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: size.height * 0.02,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )))
              ])));
    }));
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
        size: MediaQuery.of(context).size,
      ),
    );
  }
}
