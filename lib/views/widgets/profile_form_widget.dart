import 'dart:io';
import 'package:certain/blocs/authentication/authentication_bloc.dart';
import 'package:certain/blocs/authentication/authentication_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:circle_button/circle_button.dart';

import 'package:certain/blocs/profile/bloc.dart';

import 'package:certain/helpers/constants.dart';
import 'package:certain/views/widgets/gender_widget.dart';
import 'package:certain/views/widgets/interestedIn_widget.dart';

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String gender = "Female", interestedIn = "Female";
  DateTime birthdate;
  File photo;
  GeoPoint location;
  ProfileBloc _profileBloc;

  bool get isFilled =>
      _nameController.text.isNotEmpty &&
      gender != null &&
      interestedIn != null &&
      photo != null &&
      birthdate != null;

  bool isButtonEnabled(ProfileState state) {
    return isFilled && !state.isSubmitting;
  }

  _getLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    location = GeoPoint(position.latitude, position.longitude);
  }

  @override
  void initState() {
    _getLocation();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<ProfileBloc, ProfileState>(
      //cubit: _profileBloc,
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Création du profil échoué'),
                    Icon(Icons.error)
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
                    Text('Création du profil...'),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              decoration: BoxDecoration(gradient: gradient),
              width: size.width,
              height: size.height,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Positioned(
                    top: size.height * 0.12,
                    child: CircleAvatar(
                        radius: size.width * 0.20,
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
                              }
                            },
                            child: CircleAvatar(
                                radius: size.width * 0.20,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: size.width * 0.19,
                                  backgroundImage: photo == null
                                      ? AssetImage('assets/avatarphoto.png')
                                      : FileImage(photo),
                                )))),
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
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(top: size.height * 0.04),
                      height: size.height * 0.62,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[700],
                            spreadRadius: 4,
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                    child: Container(
                      height: size.height * 0.63,
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: size.height * 0.02,
                                bottom: size.height * 0.02,
                                left: size.height * 0.04,
                                right: size.height * 0.04),
                            child: TextFormField(
                              controller: _nameController,
                              cursorColor: Colors.grey[600],
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: size.height * 0.02),
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person,
                                  color: backgroundColorRed,
                                ),
                                labelText: 'Votre prénom *',
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: size.height * 0.04,
                              right: size.height * 0.04,
                              bottom: size.height * 0.04,
                            ),
                            child: TextFormField(
                              controller: _dateController,
                              cursorColor: Colors.grey[600],
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: size.height * 0.02),
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: backgroundColorRed,
                                ),
                                labelText: 'Votre date de naissance *',
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                await showDatePicker(
                                  context: context,
                                  locale: const Locale("fr", "FR"),
                                  initialDate:
                                      DateTime(DateTime.now().year - 19),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(DateTime.now().year - 19),
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Theme(
                                      data: ThemeData(
                                        colorScheme: ColorScheme(
                                          primary: backgroundColorRed,
                                          onPrimary: Colors.white,
                                          primaryVariant: backgroundColorRed,
                                          background: Colors.white,
                                          onBackground: Colors.black,
                                          secondary: backgroundColorRed,
                                          onSecondary: Colors.white,
                                          secondaryVariant: backgroundColorRed,
                                          error: Colors.black,
                                          onError: Colors.white,
                                          surface: Colors.white,
                                          onSurface: Colors.black,
                                          brightness: Brightness.light,
                                        ),
                                      ),
                                      child: child,
                                    );
                                  },
                                ).then((date) {
                                  setState(() {
                                    birthdate = date;
                                    _dateController.text =
                                        DateFormat('dd/MM/yyyy').format(date);
                                  });
                                });
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: size.height * 0.04),
                            child: Text(
                              "Vous êtes :",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: size.width * 0.04),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              genderWidget(FontAwesomeIcons.venus, "Female",
                                  size.width, gender, () {
                                setState(() {
                                  gender = "Female";
                                });
                              }),
                              genderWidget(FontAwesomeIcons.mars, "Male",
                                  size.width, gender, () {
                                setState(() {
                                  gender = "Male";
                                });
                              }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Femme",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: size.width * 0.04),
                              ),
                              SizedBox(
                                width: size.width * 0.18,
                              ),
                              Text(
                                "Homme",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: size.width * 0.04),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: size.height * 0.02),
                            padding: EdgeInsets.only(left: size.height * 0.04),
                            child: Text(
                              "Vous cherchez :",
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: size.width * 0.04),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              interestedInWidget(
                                  "Female", size.width, interestedIn, () {
                                setState(() {
                                  interestedIn = "Female";
                                });
                              }),
                              interestedInWidget(
                                  "Male", size.width, interestedIn, () {
                                setState(() {
                                  interestedIn = "Male";
                                });
                              }),
                              interestedInWidget(
                                  "Transgender", size.width, interestedIn, () {
                                setState(() {
                                  interestedIn = "Transgender";
                                });
                              }),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.03),
                            child: GestureDetector(
                              onTap: () async {
                                if (isButtonEnabled(state)) {
                                  await _getLocation();
                                  _profileBloc.add(
                                    SubmittedEvent(
                                        name: _nameController.text,
                                        birthdate: birthdate,
                                        location: location,
                                        gender: gender,
                                        interestedIn: interestedIn,
                                        photo: photo),
                                  );
                                }
                              },
                              child: Container(
                                width: size.width * 0.4,
                                height: size.height * 0.05,
                                decoration: BoxDecoration(
                                  color: isButtonEnabled(state)
                                      ? loginButtonColor
                                      : loginButtonColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Enregistrer",
                                    style: TextStyle(
                                        fontSize: size.height * 0.02,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
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
