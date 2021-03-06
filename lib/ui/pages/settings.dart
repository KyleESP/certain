import 'dart:io';

import 'package:certain/ui/widgets/photo_widget.dart';
import 'package:flutter/gestures.dart';
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
import 'package:image_picker/image_picker.dart';

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
  final picker = ImagePicker();

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

  _pickFile() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 1136, maxWidth: 640);
    setState(() {
      if (pickedFile != null) {
        photo = File(pickedFile.path);
        _settingsBloc.add(PhotoChanged(photo: photo));
      }
    });
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
            return Container(
              color: Colors.white,
              width: size.width,
              height: size.height,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Positioned(
                    top: 0,
                    child: ClipRRect(
                      child: Container(
                        height: size.height * 0.4,
                        width: size.width,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          gradient: gradient,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.045,
                    child: Text(
                      "Paramètres",
                      style: TextStyle(
                          color: Colors.white, fontSize: size.width * 0.06),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.095,
                    child: CircleAvatar(
                      radius: size.width * 0.18,
                      backgroundColor: Colors.transparent,
                      child: GestureDetector(
                        onTap: _pickFile,
                        child: CircleAvatar(
                          radius: size.width * 0.18,
                          backgroundColor: Colors.white,
                          child: photo != null
                              ? CircleAvatar(
                                  //radius: size.width * 0.12,
                                  backgroundImage: FileImage(photo),
                                )
                              : ClipOval(
                                  child: Container(
                                    height: size.width * 0.34,
                                    width: size.width * 0.34,
                                    child: PhotoWidget(
                                      photoLink: _user.photo,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.11,
                    left: size.width * 0.6,
                    child: Container(
                      width: size.width * 0.09,
                      height: size.width * 0.09,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(1.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.11,
                    left: size.width * 0.6,
                    child: CircleButton(
                      onTap: _pickFile,
                      width: size.width * 0.09,
                      height: size.width * 0.09,
                      borderStyle: BorderStyle.none,
                      backgroundColor: loginButtonColor,
                      child: Icon(
                        Icons.create,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.28,
                    child: Text(
                      _user.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    height: size.height * 0.59,
                    width: size.width,
                    padding: EdgeInsets.only(
                        left: size.width * 0.065, right: size.width * 0.065),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0.0, 2.0),
                        )
                      ],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: size.height * 0.025,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.favorite_border,
                                color: Colors.grey[700],
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Text(
                                "Préférences",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: size.height * 0.025,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.015,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Âge :",
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: size.width * 0.04),
                              ),
                              Spacer(),
                              Text(
                                _ageRange.start.toInt().toString() +
                                    "-" +
                                    _ageRange.end.toInt().toString() +
                                    " ans",
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: size.width * 0.04),
                              ),
                            ],
                          ),
                          Container(
                            width: size.width * 0.85,
                            height: size.height * 0.05,
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
                            height: size.height * 0.005,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Distance :",
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: size.width * 0.04),
                              ),
                              Spacer(),
                              Text(
                                _maxDistance.toString() + " km",
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: size.width * 0.04),
                              ),
                            ],
                          ),
                          Container(
                            width: size.width * 0.85,
                            height: size.height * 0.05,
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
                            height: size.height * 0.003,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
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
                            height: size.height * 0.015,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.person_outline,
                                color: Colors.grey[700],
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Text(
                                "Profil",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: size.height * 0.025,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Container(
                              width: size.width * 0.85,
                              child: TextFormField(
                                controller: _bioController,
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 2,
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
                          Container(
                            margin: EdgeInsets.only(left: size.width * 0.01),
                            child: Row(
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: 'Modifier votre questionnaire',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: loginButtonColor,
                                      fontSize: size.height * 0.02,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return EditMcq(userId: _user.uid);
                                          },
                                        ));
                                      },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: size.width * 0.01),
                            child: Row(
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: 'Se déconnecter',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: loginButtonColor,
                                      fontSize: size.height * 0.02,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        BlocProvider.of<AuthenticationBloc>(
                                                context)
                                            .add(LoggedOut());
                                      },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
