import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/sign_up/bloc.dart';
import 'package:certain/blocs/authentication/authentication_bloc.dart';
import 'package:certain/blocs/authentication/authentication_event.dart';

import 'package:certain/repositories/user_repository.dart';

import 'package:certain/helpers/functions.dart';
import 'package:certain/helpers/constants.dart';

class SignUp extends StatelessWidget {
  final UserRepository _userRepository;

  SignUp({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(_userRepository),
        child: SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUpBloc _signUpBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isSignUpButtonEnabled(SignUpState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);

    _emailController.addListener(() => _signUpBloc.add(
          EmailChanged(email: _emailController.text),
        ));
    _passwordController.addListener(() => _signUpBloc.add(
          PasswordChanged(password: _passwordController.text),
        ));

    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  void _onFormSubmitted() {
    _signUpBloc.add(
      SignUpWithCredentialsPressed(
          email: _emailController.text, password: _passwordController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (BuildContext context, SignUpState state) {
        if (state.isFailure) {
          scaffoldInfo(context, state.errorMessage, Icon(Icons.error));
        }
        if (state.isSubmitting) {
          scaffoldInfo(
              context,
              "Création du compte...",
              CircularProgressIndicator(
                backgroundColor: loginButtonColor,
                valueColor:
                    AlwaysStoppedAnimation<Color>(backgroundColorOrange),
              ));
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              decoration: BoxDecoration(gradient: gradient),
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    heightFactor: 1.5,
                    child: Image.asset('assets/images/logo_add.png',
                        height: 200, width: 200),
                  ),
                  Container(
                    child: Text(
                      "Créer votre compte",
                      style: TextStyle(
                          fontSize: size.width * 0.07, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
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
                    child: GestureDetector(
                      onTap: isSignUpButtonEnabled(state)
                          ? _onFormSubmitted
                          : null,
                      child: Container(
                        width: size.width * 0.5,
                        height: size.height * 0.06,
                        decoration: BoxDecoration(
                          color: isSignUpButtonEnabled(state)
                              ? loginButtonColor
                              : loginButtonColor.withOpacity(0.3),
                          borderRadius:
                              BorderRadius.circular(size.height * 0.05),
                        ),
                        child: Center(
                          child: Text(
                            "Créer",
                            style: TextStyle(
                                fontSize: size.height * 0.023,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
