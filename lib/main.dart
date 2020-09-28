import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_event.dart';
import 'blocs/my_bloc_observer.dart';

import 'repositories/userRepository.dart';

import 'views/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  final UserRepository userRepository = UserRepository();

  runApp(BlocProvider(
      create: (context) =>
          AuthenticationBloc(userRepository)..add(AppStarted()),
      child: Home(userRepository: userRepository)));
}
