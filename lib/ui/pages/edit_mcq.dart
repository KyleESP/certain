import 'package:certain/helpers/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/edit_mcq/bloc.dart';

import 'package:certain/models/question_model.dart';
import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/questions_repository.dart';

import 'package:certain/ui/widgets/play_qcm_widgets.dart';
import 'package:certain/ui/widgets/loader_widget.dart';

import 'package:certain/helpers/constants.dart';

class EditMcq extends StatelessWidget {
  final _questionsRepository = new QuestionsRepository();
  final UserModel user;

  EditMcq({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<EditMcqBloc>(
        create: (context) => EditMcqBloc(_questionsRepository),
        child: EditMcqForm(user: user),
      ),
    );
  }
}

class EditMcqForm extends StatefulWidget {
  final UserModel user;

  EditMcqForm({this.user});

  @override
  _EditMcqFormState createState() => _EditMcqFormState();
}

class _EditMcqFormState extends State<EditMcqForm> {
  EditMcqBloc _editMcqBloc;
  List<QuestionModel> _mcq;
  String _optionSelected;
  QuestionModel _questionSelected;
  List<Map<String, String>> _userQuestions = [];

  bool get isLastQuestion => _mcq.length == 1;

  bool get isButtonEnabled =>
      _questionSelected != null && _optionSelected != null;

  @override
  void initState() {
    _editMcqBloc = BlocProvider.of<EditMcqBloc>(context);
    _mcq = widget.user.mcq;
    _questionSelected = _mcq[0];
    _optionSelected = _questionSelected.option1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return BlocListener<EditMcqBloc, EditMcqState>(listener: (context, state) {
      if (state.isFailure) {
        scaffoldInfo(context, "Mise à jour du QCM échouée", Icon(Icons.error));
      }
      if (state.isSubmitting) {
        scaffoldInfo(
            context,
            "Mise à jour du QCM...",
            CircularProgressIndicator(
              backgroundColor: loginButtonColor,
              valueColor: AlwaysStoppedAnimation<Color>(backgroundColorOrange),
            ));
      }
      if (state.isSuccess) {
        scaffoldInfo(context, "Mise à jour réussi",
            Icon(Icons.done, color: backgroundColorOrange));
        Navigator.pop(context);
      }
    }, child: BlocBuilder<EditMcqBloc, EditMcqState>(builder: (context, state) {
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
                    optionWidget(_questionSelected.option1, "A"),
                    optionWidget(_questionSelected.option2, "B"),
                    optionWidget(_questionSelected.option3, "C"),
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isButtonEnabled) {
                              var optionsRemaining = [
                                _questionSelected.option1,
                                _questionSelected.option2,
                                _questionSelected.option3
                              ]..remove(_optionSelected);

                              if (isLastQuestion) {
                                _userQuestions.add({
                                  "question": _questionSelected.question,
                                  "correct_answer": _optionSelected,
                                  "option_2": optionsRemaining[0],
                                  "option_3": optionsRemaining[1],
                                });

                                _editMcqBloc.add(
                                  SubmittedMcqEvent(
                                      userId: widget.user.uid,
                                      userQuestions: _userQuestions),
                                );
                              } else {
                                setState(() {
                                  _userQuestions.add({
                                    "question": _questionSelected.question,
                                    "correct_answer": _optionSelected,
                                    "option_2": optionsRemaining[0],
                                    "option_3": optionsRemaining[1],
                                  });

                                  _mcq.remove(_questionSelected);
                                  _questionSelected = _mcq[0];
                                  _optionSelected = _questionSelected.option1;
                                });
                              }
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
                                  : "Terminer les modifications",
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
