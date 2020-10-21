import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';

import 'package:certain/blocs/authentication/authentication_bloc.dart';
import 'package:certain/blocs/authentication/authentication_event.dart';
import 'package:certain/blocs/sign_in/bloc.dart';

import 'package:certain/repositories/user_repository.dart';

import 'package:certain/ui/pages/sign_up.dart';

import 'package:certain/helpers/functions.dart';
import 'package:certain/helpers/constants.dart';

class SignIn extends StatelessWidget {
  final UserRepository _userRepository;

  SignIn({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SignInBloc>(
        create: (context) => SignInBloc(_userRepository),
        child: SignInForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  final UserRepository _userRepository;

  SignInForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SignInBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(SignInState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _loginBloc = BlocProvider.of<SignInBloc>(context);

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

    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state.isFailure) {
          scaffoldInfo(context, state.errorMessage, Icon(Icons.error));
        }
        if (state.isSubmitting) {
          scaffoldInfo(
              context,
              "Connexion...",
              CircularProgressIndicator(
                backgroundColor: loginButtonColor,
                valueColor:
                    AlwaysStoppedAnimation<Color>(backgroundColorOrange),
              ));
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<SignInBloc, SignInState>(
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
                    backgroundColorRed,
                    backgroundColorOrange,
                    backgroundColorYellow
                  ])),
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.15),
                    child: Image.asset('assets/images/logo.png',
                        height: 200, width: 200),
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
                      cursorColor: Colors.white,
                      style: TextStyle(
                          color: Colors.white, fontSize: size.height * 0.02),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(size.height * 0.02),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        hintText: "Email",
                        hintStyle: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.02),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
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
                      cursorColor: Colors.white,
                      style: TextStyle(
                          color: Colors.white, fontSize: size.height * 0.02),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(size.height * 0.02),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        hintText: "Mot de passe",
                        hintStyle: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.02),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
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
                                  ? loginButtonColor
                                  : loginButtonColor.withOpacity(0.3),
                              borderRadius:
                                  BorderRadius.circular(size.height * 0.05),
                            ),
                            child: Center(
                              child: Text(
                                "Se connecter",
                                style: TextStyle(
                                    fontSize: size.height * 0.023,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(size.height * 0.02),
                    margin: EdgeInsets.only(top: size.height * 0.18),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Vous n\'êtes pas encore inscrit ? ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.02,
                            ),
                          ),
                          TextSpan(
                            text: 'Inscrivez-vous',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: loginButtonColor,
                              fontSize: size.height * 0.02,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
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
                          ),
                        ],
                      ),
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
