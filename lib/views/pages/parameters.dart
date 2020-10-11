import 'package:certain/blocs/parameters/parameters_bloc.dart';
import 'package:certain/repositories/user_repository.dart';
import 'package:certain/views/widgets/parameters_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Parameters extends StatefulWidget {
  final String userId;

  const Parameters({this.userId});

  @override
  _ParametersState createState() => _ParametersState();
}

class _ParametersState extends State<Parameters> {
  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ParametersBloc>(
        create: (context) => ParametersBloc(_userRepository),
        child: ParametersForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}
