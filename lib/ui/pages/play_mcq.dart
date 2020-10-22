import 'package:certain/blocs/play_mcq/play_mcq_bloc.dart';
import 'package:certain/blocs/play_mcq/play_mcq_event.dart';
import 'package:certain/blocs/play_mcq/play_mcq_state.dart';
import 'package:certain/ui/widgets/loader_widget.dart';
import 'package:certain/ui/widgets/profile_widget.dart';
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
  int _mcqSize;
  List<String> _optionsShuffled = [];

  bool get isLastQuestion => _mcq.length == 1;

  bool get isButtonEnabled =>
      _questionSelected != null && _optionSelected != null;

  @override
  void initState() {
    _playMcqBloc = BlocProvider.of<PlayMcqBloc>(context);
    _mcq = widget.selectedUser.mcq;
    _mcqSize = _mcq.length;
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
      if (state.isCompleted) {
        var message = "";
        if (state.status == "w") {
          message =
              "Vous avez réussi le QCM. Patientez que l'autre réussisse aussi.";
        } else if (state.status == "s") {
          message =
              "Vous avez tout deux réussi vos QCM. Vous pouvez maintenant parler.";
        } else {
          message = "Vous avez raté le QCM... Dommage !";
        }
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              });
              return Dialog(
                backgroundColor: Colors.transparent,
                child: profileWidget(
                  photo: widget.selectedUser.photo,
                  photoHeight: size.height,
                  padding: size.height * 0.01,
                  photoWidth: size.width,
                  clipRadius: size.height * 0.01,
                  containerWidth: size.width,
                  containerHeight: size.height * 0.2,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.height * 0.02),
                    child: Text(
                      message,
                      style: TextStyle(
                          color: Colors.red, fontSize: size.height * 0.02),
                    ),
                  ),
                ),
              );
            });
      }
    }, child: BlocBuilder<PlayMcqBloc, PlayMcqState>(builder: (context, state) {
      if (state is LoadingState) {
        return loaderWidget();
      }
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
                            if (isLastQuestion) {
                              var successPercentage = _correct / _mcqSize;
                              _playMcqBloc.add(CompletedEvent(
                                  currentUserId: widget.user.uid,
                                  selectedUserId: widget.selectedUser.uid,
                                  status:
                                      successPercentage >= 0.5 ? "s" : "f"));
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
                            width: MediaQuery.of(context).size.width / 2 - 40,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                                color: isButtonEnabled
                                    ? loginButtonColor
                                    : loginButtonColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              !isLastQuestion
                                  ? "Prochaine question"
                                  : "Terminer",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )));
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
      ),
    );
  }
}
