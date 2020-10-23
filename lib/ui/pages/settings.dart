import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:circle_button/circle_button.dart';

import 'package:certain/blocs/authentication/authentication_bloc.dart';
import 'package:certain/blocs/authentication/authentication_event.dart';
import 'package:certain/blocs/settings/bloc.dart';

import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/user_repository.dart';

import 'package:certain/ui/widgets/loader_widget.dart';
import 'package:certain/ui/widgets/interestedIn_widget.dart';

import 'package:certain/helpers/functions.dart';
import 'package:certain/helpers/constants.dart';

import 'edit_mcq.dart';

class Settings extends StatefulWidget {
  final String userId;

  const Settings({this.userId});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _bioController = TextEditingController();
  final UserRepository _userRepository = UserRepository();
  SettingsBloc _settingsBloc;
  UserModel _user;
  String _interestedIn;
  File photo;
  int _maxDistance;
  RangeValues _ageRange;

  @override
  void initState() {
    _settingsBloc = SettingsBloc(_userRepository);
    super.initState();
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  _onTapInterestedIn(interestedIn) {
    return () async {
      setState(() {
        this._interestedIn = interestedIn;
      });
      _settingsBloc.add(InterestedInChanged(interestedIn: _interestedIn));
    };
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<SettingsBloc, SettingsState>(
        cubit: _settingsBloc,
        listener: (context, state) {
          if (state.isFailure) {
            scaffoldInfo(context, "Mise à jour échouée", Icon(Icons.error));
          }
          if (state.isSubmitting) {
            scaffoldInfo(
                context,
                "Mise à jour...",
                CircularProgressIndicator(
                  backgroundColor: loginButtonColor,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(backgroundColorOrange),
                ));
          }
          if (state.isSuccess) {
            scaffoldInfo(
                context,
                "Mise à jour réussi",
                Icon(
                  Icons.done,
                  color: backgroundColorOrange,
                ));
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
          cubit: _settingsBloc,
          builder: (context, state) {
            if (state is SettingsInitialState) {
              _settingsBloc.add(
                LoadUserEvent(userId: widget.userId),
              );
              return loaderWidget();
            }
            if (state is LoadingState) {
              return loaderWidget();
            }
            if (state is LoadUserState) {
              _user = state.user;
              _maxDistance = _user.maxDistance;
              _ageRange =
                  RangeValues(_user.minAge.toDouble(), _user.maxAge.toDouble());
              _interestedIn = _user.interestedIn;
              _bioController.text = _user.bio;
            }
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
                            color: Colors.white, fontSize: size.width * 0.06),
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.12,
                      child: CircleAvatar(
                        radius: size.width * 0.2,
                        backgroundColor: Colors.transparent,
                        child: GestureDetector(
                          onTap: () async {
                            FilePickerResult result = await FilePicker.platform
                                .pickFiles(type: FileType.image);
                            if (result != null) {
                              File getPic = File(result.files.single.path);
                              setState(() {
                                photo = getPic;
                              });
                              _settingsBloc.add(PhotoChanged(photo: photo));
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
                      top: size.height * 0.13,
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
                      top: size.height * 0.13,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: size.height * 0.35,
                        ),
                        Container(
                            width: size.width * 0.85,
                            child: TextFormField(
                              controller: _bioController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              maxLength: 300,
                              cursorColor: Colors.grey[600],
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: size.height * 0.018),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  color: backgroundColorRed,
                                  onPressed: () {
                                    _settingsBloc.add(
                                        BioChanged(bio: _bioController.text));
                                  },
                                  icon: Icon(Icons.update),
                                ),
                                labelText: 'Votre bio',
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: size.height * 0.02,
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
                              _ageRange.start.toInt().toString() +
                                  "-" +
                                  _ageRange.end.toInt().toString() +
                                  " ans",
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
                              _settingsBloc.add(AgeRangeChanged(
                                  minAge: endValues.start.toInt(),
                                  maxAge: endValues.end.toInt()));
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
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
                              _maxDistance.toString() + " km",
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
                              _settingsBloc.add(MaxDistanceChanged(
                                  maxDistance: newValue.toInt()));
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.015,
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
                            interestedInWidget("f", size.width, _interestedIn,
                                _onTapInterestedIn("f")),
                            interestedInWidget("m", size.width, _interestedIn,
                                _onTapInterestedIn("m")),
                            interestedInWidget("b", size.width, _interestedIn,
                                _onTapInterestedIn("b")),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: logoutButton,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return EditMcq(user: _user);
                              },
                            ));
                          },
                          child: Text(
                            "Modifier votre QCM",
                            style: TextStyle(
                                fontSize: size.height * 0.02,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
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
          },
        ));
  }
}
