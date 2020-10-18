import 'dart:io';

import 'package:certain/blocs/authentication/authentication_bloc.dart';
import 'package:certain/blocs/authentication/authentication_event.dart';
import 'package:certain/blocs/parameters/parameters_bloc.dart';
import 'package:certain/blocs/parameters/parameters_event.dart';
import 'package:certain/blocs/parameters/parameters_state.dart';
import 'package:certain/helpers/functions.dart';
import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/user_repository.dart';
import 'package:certain/ui/widgets/gender_widget.dart';
import 'package:certain/ui/widgets/loader_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                  color: backgroundColor,
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: size.width,
                        child: CircleAvatar(
                          radius: size.width * 0.3,
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
                              radius: size.width * 0.3,
                              backgroundImage: photo != null
                                  ? FileImage(photo)
                                  : NetworkImage(_user.photo),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Slider(
                        value: _maxDistance.toDouble(),
                        min: 1,
                        max: 100,
                        divisions: _maxDistance,
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
                      RangeSlider(
                        values: _ageRange,
                        min: 18,
                        max: 55,
                        divisions: 55 - 18,
                        labels: RangeLabels(_ageRange.start.toInt().toString(),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              genderWidget(
                                  FontAwesomeIcons.venus,
                                  "Female",
                                  size.width,
                                  _interestedIn,
                                  _onTapInterestedIn("Female")),
                              genderWidget(
                                  FontAwesomeIcons.mars,
                                  "Male",
                                  size.width,
                                  _interestedIn,
                                  _onTapInterestedIn("Male")),
                              genderWidget(
                                  FontAwesomeIcons.transgender,
                                  "Transgender",
                                  size.width,
                                  _interestedIn,
                                  _onTapInterestedIn("Transgender")),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: RaisedButton(
                          onPressed: () => {
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(LoggedOut())
                          },
                          child: Text("Se déconnecter"),
                        ),
                      )
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
