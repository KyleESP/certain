import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/authentication/authentication_bloc.dart';
import 'package:certain/blocs/authentication/authentication_event.dart';
import 'package:certain/blocs/login/bloc.dart';

import 'package:certain/repositories/user_repository.dart';

import 'package:certain/views/pages/sign_up.dart';
import 'package:certain/views/constants.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
          email: _emailController.text, password: _passwordController.text),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Connexion échouée"),
                    Icon(Icons.error),
                  ],
                ),
              ),
            );
        }

        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Connexion..."),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }

        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [
                        0.3,
                        0.6,
                        1.0
                      ],
                      colors: [
                        Colors.red[300],
                        Colors.deepOrangeAccent[100],
                        Colors.amber[200]
                      ]
                  )
              ),
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Certain",
                      style: TextStyle(
                          fontSize: size.width * 0.2, color: Colors.white),
                    ),
                  ),
                  Container(
                    width: size.width * 0.8,
                    child: Divider(
                      height: size.height * 0.05,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(size.height * 0.02),
                    width: size.width * 0.9,
                    child: TextFormField(
                      controller: _emailController,
                      autovalidate: true,
                      validator: (_) {
                        return !state.isEmailValid ? "Email invalide" : null;
                      },
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.025
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        hintText: "Email",
                        hintStyle: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.025),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(size.height * 0.02),
                    width: size.width * 0.9,
                    child: TextFormField(
                      controller: _passwordController,
                      autocorrect: false,
                      obscureText: true,
                      autovalidate: true,
                      validator: (_) {
                        return !state.isPasswordValid
                            ? "Mot de passe invalide"
                            : null;
                      },
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.025
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        hintText: "Mot de passe",
                        hintStyle: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.025),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.height * 0.02),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: isLoginButtonEnabled(state)
                              ? _onFormSubmitted
                              : null,
                          child: Container(
                            width: size.width * 0.6,
                            height: size.height * 0.06,
                            decoration: BoxDecoration(
                              color: isLoginButtonEnabled(state)
                                  ? Color(0xFFE04A5A)
                                  : Color(0xFFE04A5A).withOpacity(0.3),
                              borderRadius:
                                  BorderRadius.circular(size.height * 0.05),
                            ),
                            child: Center(
                              child: Text(
                                "Se connecter",
                                style: TextStyle(
                                    fontSize: size.height * 0.025,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignUp(
                                    userRepository: _userRepository,
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            "Créer un compte",
                            style: TextStyle(
                                fontSize: size.height * 0.025,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
