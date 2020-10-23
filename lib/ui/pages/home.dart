import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/authentication/authentication_bloc.dart';
import 'package:certain/blocs/authentication/authentication_state.dart';

import 'package:certain/repositories/user_repository.dart';

import 'package:certain/ui/pages/profile.dart';
import 'package:certain/ui/pages/splash_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'bottom_tab.dart';
import 'sign_in.dart';
import 'create_mcq.dart';

class Home extends StatelessWidget {
  final UserRepository _userRepository;

  Home({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr', 'FR'),
      ],
      theme: ThemeData(fontFamily: 'Montserrat'),
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return SplashScreen();
          }
          if (state is Authenticated) {
            return BottomTab(
              userId: state.userId,
            );
          }
          if (state is AuthenticatedButMcqNotSet) {
            return CreateMcq(state.userId);
          }
          if (state is AuthenticatedButProfileNotSet) {
            return Profile(
              userRepository: _userRepository,
              userId: state.userId,
            );
          }
          if (state is Unauthenticated) {
            return SignIn(
              userRepository: _userRepository,
            );
          } else
            return Container();
        },
      ),
    );
  }
}
