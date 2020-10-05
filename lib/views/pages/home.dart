import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/authentication/authentication_bloc.dart';
import 'package:certain/blocs/authentication/authentication_state.dart';

import 'package:certain/repositories/user_repository.dart';

import 'package:certain/views/pages/profile.dart';
import 'package:certain/views/pages/splash_screen.dart';
import 'package:certain/views/widgets/tabs_widget.dart';

import 'login.dart';

class Home extends StatelessWidget {
  final UserRepository _userRepository;

  Home({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return Splash();
          }
          if (state is Authenticated) {
            return Tabs(
              userId: state.userId,
            );
          }
          if (state is AuthenticatedButNotSet) {
            return Profile(
              userRepository: _userRepository,
              userId: state.userId,
            );
          }
          if (state is Unauthenticated) {
            return Login(
              userRepository: _userRepository,
            );
          } else
            return Container();
        },
      ),
    );
  }
}
