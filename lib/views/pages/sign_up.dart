import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/sign_up/bloc.dart';

import 'package:certain/repositories/user_repository.dart';

import 'package:certain/views/constants.dart';
import 'package:certain/views/widgets/sign_up_form_widget.dart';

class SignUp extends StatelessWidget {
  final UserRepository _userRepository;

  SignUp({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Création du compte",
          style: TextStyle(fontSize: 36.0),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(_userRepository),
        child: SignUpForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}
