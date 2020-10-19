import 'dart:io';

import 'package:certain/blocs/authentication/authentication_bloc.dart';
import 'package:certain/blocs/authentication/authentication_event.dart';
import 'package:certain/blocs/parameters/parameters_bloc.dart';
import 'package:certain/blocs/parameters/parameters_event.dart';
import 'package:certain/blocs/parameters/parameters_state.dart';
import 'package:certain/helpers/functions.dart';
import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/user_repository.dart';
import 'package:certain/ui/widgets/interestedIn_widget.dart';
import 'package:certain/ui/widgets/loader_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:circle_button/circle_button.dart';

import 'package:certain/helpers/constants.dart';

class Parameters extends StatefulWidget {
  final String userId;

  const Parameters({this.userId});

  @override
  _ParametersState createState() => _ParametersState();
}

class _ParametersState extends State<Parameters> {
  final UserRepository _userRepository = UserRepository();
  ParametersBloc _parametersBloc;
  UserModel _user;
  String _interestedIn;
  File photo;
  int _maxDistance;
  RangeValues _ageRange;

  @override
  void initState() {
    _parametersBloc = ParametersBloc(_userRepository);
    super.initState();
  }

  _onTapInterestedIn(interestedIn) {
    return () async {
      setState(() {
        this._interestedIn = interestedIn;
      });
      _parametersBloc.add(InterestedInChanged(interestedIn: _interestedIn));
    };
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<ParametersBloc, ParametersState>(
        cubit: _parametersBloc,
        listener: (context, state) {
          if (state.isFailure) {
            scaffoldInfo(context, "Mise à jour échouée", Icon(Icons.error));
          }
        },
        child: BlocBuilder<ParametersBloc, ParametersState>(
          cubit: _parametersBloc,
          builder: (context, state) {
            if (state is ParametersInitialState) {
              _parametersBloc.add(
                LoadUserEvent(userId: widget.userId),
              );
              return loaderWidget();
            }
            if (state is LoadingState) {
              return loaderWidget();
            }
            if (state is LoadUserState) {
              _user = state.user;
              _maxDistance ??= _user.maxDistance;
              _ageRange ??=
                  RangeValues(_user.minAge.toDouble(), _user.maxAge.toDouble());
              _interestedIn ??= _user.interestedIn;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  color: Colors.white,
                  width: size.width,
                  height: size.height,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.elliptical(200.0, 100.0),
                              bottomRight: Radius.elliptical(200.0, 100.0)),
                          child: Container(
                            height: size.height * 0.27,
                            width: size.width,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              gradient: gradient,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.06,
                        child: Text(
                          "Paramètres",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.06),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.14,
                        child: CircleAvatar(
                          radius: size.width * 0.2,
                          backgroundColor: Colors.transparent,
                          child: GestureDetector(
                            onTap: () async {
                              FilePickerResult result = await FilePicker
                                  .platform
                                  .pickFiles(type: FileType.image);
                              if (result != null) {
                                File getPic = File(result.files.single.path);
                                setState(() {
                                  photo = getPic;
                                });
                                _parametersBloc.add(PhotoChanged(photo: photo));
                              }
                            },
                            child: CircleAvatar(
                              radius: size.width * 0.20,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: size.width * 0.19,
                                backgroundImage: photo != null
                                    ? FileImage(photo)
                                    : NetworkImage(_user.photo),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.15,
                        left: size.width * 0.6,
                        child: Container(
                          width: size.width * 0.08,
                          height: size.width * 0.09,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[800],
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(-0.5, 3.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.15,
                        left: size.width * 0.6,
                        child: CircleButton(
                          onTap: () async {
                            FilePickerResult result = await FilePicker.platform
                                .pickFiles(type: FileType.image);
                            if (result != null) {
                              File getPic = File(result.files.single.path);
                              setState(() {
                                photo = getPic;
                              });
                            }
                          },
                          width: size.width * 0.1,
                          height: size.width * 0.1,
                          borderStyle: BorderStyle.none,
                          backgroundColor: loginButtonColor,
                          child: Icon(
                            Icons.create,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: size.height * 0.25,
                          ),
                          Row(
                            children: <Widget>[
                              Spacer(),
                              Text(
                                "Âge :",
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: size.width * 0.04),
                              ),
                              Spacer(flex: 7),
                              Text(
                                _ageRange.start.toInt().toString()+"-"+_ageRange.end.toInt().toString()+" ans",
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: size.width * 0.04),
                              ),
                              Spacer(),
                            ],
                          ),
                          Container(
                            width: size.width * 0.85,
                            child: RangeSlider(
                              values: _ageRange,
                              min: 18,
                              max: 55,
                              divisions: 55 - 18,
                              activeColor: loginButtonColor,
                              inactiveColor: loginButtonColor.withOpacity(0.2),
                              labels: RangeLabels(
                                  _ageRange.start.toInt().toString(),
                                  _ageRange.end.toInt().toString()),
                              onChanged: (RangeValues newValues) {
                                setState(() {
                                  _ageRange = newValues;
                                });
                              },
                              onChangeEnd: (RangeValues endValues) {
                                _parametersBloc.add(AgeRangeChanged(
                                    minAge: endValues.start.toInt(),
                                    maxAge: endValues.end.toInt()));
                              },
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                         Row(
                           children: <Widget>[
                             Spacer(),
                             Text(
                              "Distance :",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: size.width * 0.04),
                            ),
                             Spacer(flex: 7),
                             Text(
                               _maxDistance.toString()+" km",
                               style: TextStyle(
                                   color: Colors.grey[700],
                                   fontSize: size.width * 0.04),
                             ),
                             Spacer(),
                            ],
                          ),
                          Container(
                            width: size.width * 0.85,
                            child: Slider(
                              value: _maxDistance.toDouble(),
                              min: 1,
                              max: 100,
                              divisions: _maxDistance,
                              activeColor: loginButtonColor,
                              inactiveColor: loginButtonColor.withOpacity(0.2),
                              label: '$_maxDistance',
                              onChanged: (double newValue) {
                                setState(() {
                                  _maxDistance = newValue.toInt();
                                });
                              },
                              onChangeEnd: (double newValue) {
                                _parametersBloc.add(MaxDistanceChanged(
                                    maxDistance: newValue.toInt()));
                              },
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: size.height * 0.04),
                            margin: EdgeInsets.only(bottom: size.height * 0.01),
                            child: Text(
                              "Vous cherchez :",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: size.width * 0.04),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              interestedInWidget("Female", size.width,
                                  _interestedIn, _onTapInterestedIn("Female")),
                              interestedInWidget("Male", size.width,
                                  _interestedIn, _onTapInterestedIn("Male")),
                              interestedInWidget(
                                  "Transgender",
                                  size.width,
                                  _interestedIn,
                                  _onTapInterestedIn("Transgender")),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            color: logoutButton,
                            onPressed: () => {
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .add(LoggedOut())
                            },
                            child: Text(
                              "Se déconnecter",
                              style: TextStyle(
                                  fontSize: size.height * 0.02,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else
              return Container();
          },
        ));
  }
}
