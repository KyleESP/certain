import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/questions/questions_bloc.dart';

import 'package:certain/repositories/questions_repository.dart';

import 'package:certain/views/widgets/mcq_form_widget.dart';

class Mcq extends StatelessWidget {
  final _questionsRepository = new QuestionsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<QuestionsBloc>(
        create: (context) => QuestionsBloc(_questionsRepository),
        child: McqForm(),
      ),
    );
  }
}
