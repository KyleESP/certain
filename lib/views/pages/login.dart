import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';

import 'package:certain/blocs/login/bloc.dart';

import 'package:certain/repositories/userRepository.dart';

import 'package:certain/views/widgets/loginForm.dart';

class Login extends StatelessWidget {
  final UserRepository _userRepository;

  Login({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(_userRepository),
        child: LoginForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}
