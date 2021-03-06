import 'package:certain/seeders/user_seeder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_event.dart';
import 'blocs/simple_bloc_observer.dart';

import 'repositories/user_repository.dart';

import 'ui/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();

  /*UserSeeder userSeeder = UserSeeder();
  userSeeder.addUsers(true);*/

  Bloc.observer = SimpleBlocObserver();
  final UserRepository userRepository = UserRepository();

  runApp(BlocProvider(
      create: (context) =>
          AuthenticationBloc(userRepository)..add(AppStarted()),
      child: Home(userRepository: userRepository)));
}
