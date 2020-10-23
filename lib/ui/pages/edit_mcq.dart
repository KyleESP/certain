import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/edit_mcq/bloc.dart';

import 'package:certain/models/question_model.dart';
import 'package:certain/repositories/questions_repository.dart';

import 'package:certain/ui/widgets/play_qcm_widgets.dart';
import 'package:certain/ui/widgets/loader_widget.dart';

import 'package:certain/helpers/constants.dart';
import 'package:certain/helpers/functions.dart';

class EditMcq extends StatelessWidget {
  final _questionsRepository = new QuestionsRepository();
  final String userId;

  EditMcq({@required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<EditMcqBloc>(
        create: (context) => EditMcqBloc(_questionsRepository),
        child: EditMcqForm(userId: userId),
      ),
    );
  }
}

class EditMcqForm extends StatefulWidget {
  final String userId;

  EditMcqForm({this.userId});

  @override
  _EditMcqFormState createState() => _EditMcqFormState();
}

class _EditMcqFormState extends State<EditMcqForm> {
  EditMcqBloc _editMcqBloc;
  List<QuestionModel> _mcq;
  String _optionSelected;
  QuestionModel _questionSelected;
  List<Map<String, String>> _userQuestions = [];
  List<QuestionModel> _questionList = [];
  Random random = new Random();

  bool get isLastQuestion => _mcq.length == 1;

  bool get isButtonEnabled =>
      _questionSelected != null && _optionSelected != null;

  @override
  void initState() {
    _editMcqBloc = BlocProvider.of<EditMcqBloc>(context);
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
      if (state is EditMcqInitialState) {
        _editMcqBloc.add(LoadMcqEvent(widget.userId));
        return loaderWidget();
      }
      if (state is LoadingState) {
        return loaderWidget();
      }
      if (state is LoadMcqState) {
        _mcq = state.mcq;
        _questionList = state.questionList;
        _questionSelected = _mcq[0];
        _optionSelected = _questionSelected.option1;
        _editMcqBloc.add(LoadedMcqEvent());
      }
      if (state is ShowMcqState) {
        var _questionListCopy = _questionList;
        for (var q in _userQuestions) {
          _questionListCopy
              .removeWhere((item) => item.question == q['question']);
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
                      Text("Question ${7 - _mcq.length}/6"),
                      DropdownSearch<QuestionModel>(
                        mode: Mode.BOTTOM_SHEET,
                        items: _questionListCopy,
                        selectedItem: _questionSelected,
                        isFilteredOnline: true,
                        showSearchBox: true,
                        label: 'Question *',
                        dropdownSearchDecoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor),
                        autoValidate: true,
                        validator: (QuestionModel u) =>
                            u == null ? "Question field is required " : null,
                        onChanged: (QuestionModel q) {
                          setState(() {
                            _questionSelected = q;
                            _optionSelected = null;
                          });
                        },
                      ),
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
                                        userId: widget.userId,
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

                                    _mcq.removeAt(0);
                                    var exist = false;
                                    for (var q in _mcq) {
                                      if (q.question ==
                                          _questionSelected.question) {
                                        exist = true;
                                        break;
                                      }
                                    }
                                    _questionSelected = exist
                                        ? _questionList[random
                                            .nextInt(_questionList.length)]
                                        : _mcq[0];
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
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )));
      } else {
        return Container();
      }
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
