import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';

import 'package:certain/blocs/create_mcq/bloc.dart';
import 'package:certain/blocs/authentication/authentication_bloc.dart';
import 'package:certain/blocs/authentication/authentication_event.dart';

import 'package:certain/models/question_model.dart';
import 'package:certain/repositories/questions_repository.dart';

import 'package:certain/ui/widgets/play_qcm_widgets.dart';
import 'package:certain/ui/widgets/loader_widget.dart';

import 'package:certain/helpers/constants.dart';
import 'package:certain/helpers/functions.dart';

class CreateMcq extends StatelessWidget {
  final _questionsRepository = new QuestionsRepository();
  final String userId;

  CreateMcq(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<CreateMcqBloc>(
        create: (context) => CreateMcqBloc(_questionsRepository),
        child: CreateMcqForm(userId),
      ),
    );
  }
}

class CreateMcqForm extends StatefulWidget {
  final String userId;

  CreateMcqForm(this.userId);

  @override
  _CreateMcqFormState createState() => _CreateMcqFormState();
}

class _CreateMcqFormState extends State<CreateMcqForm> {
  CreateMcqBloc _createMcqBloc;
  List<QuestionModel> _questionList;
  String _optionSelected;
  QuestionModel _questionSelected;
  List<Map<String, String>> _userQuestions = [];

  bool get isQuestionCompleted =>
      _questionSelected != null && _optionSelected != null;

  bool get isLastQuestion => _userQuestions.length >= 5;

  bool isButtonEnabled(CreateMcqState state) {
    return isQuestionCompleted && !state.isSubmitting;
  }

  @override
  void initState() {
    _createMcqBloc = BlocProvider.of<CreateMcqBloc>(context);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return BlocListener<CreateMcqBloc, CreateMcqState>(listener:
        (context, state) {
      if (state.isFailure) {
        scaffoldInfo(context, "Création du QCM échouée", Icon(Icons.error));
      }
      if (state.isSubmitting) {
        scaffoldInfo(
            context,
            "Création du QCM...",
            CircularProgressIndicator(
              backgroundColor: loginButtonColor,
              valueColor: AlwaysStoppedAnimation<Color>(backgroundColorOrange),
            ));
      }
      if (state.isSuccess) {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
      }
    }, child:
        BlocBuilder<CreateMcqBloc, CreateMcqState>(builder: (context, state) {
      if (state is QuestionsInitialState) {
        _createMcqBloc.add(
          LoadQuestionsEvent(),
        );
        return loaderWidget();
      }
      if (state is LoadingState) {
        return loaderWidget();
      }
      if (state is LoadQuestionsState) {
        _questionList = state.questionList;
        _questionSelected = _questionList[0];
        _createMcqBloc.add(LoadQuestionEvent());
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
                    Text("Question ${_userQuestions.length + 1}/6"),
                    DropdownSearch<QuestionModel>(
                      mode: Mode.BOTTOM_SHEET,
                      items: _questionList,
                      selectedItem: _questionSelected,
                      isFilteredOnline: true,
                      showSearchBox: true,
                      label: 'Question *',
                      dropdownSearchDecoration: InputDecoration(
                          filled: true,
                          fillColor:
                              Theme.of(context).inputDecorationTheme.fillColor),
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
                    if (_questionSelected != null) ...[
                      optionWidget(_questionSelected.option1, "A"),
                      optionWidget(_questionSelected.option2, "B"),
                      optionWidget(_questionSelected.option3, "C"),
                    ],
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (isButtonEnabled(state)) {
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

                                _createMcqBloc.add(
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

                                  _questionList.remove(_questionSelected);
                                  _questionSelected = _questionList[0];
                                  _optionSelected = null;
                                });
                              }
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                                color: isButtonEnabled(state)
                                    ? loginButtonColor
                                    : loginButtonColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              !isLastQuestion
                                  ? "Ajouter une autre question"
                                  : "Créér le QCM",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ],
                ),
              )));
    }));
  }
}
