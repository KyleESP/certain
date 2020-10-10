import 'dart:io';
import 'package:certain/views/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import 'package:certain/blocs/authentication/authentication_bloc.dart';
import 'package:certain/blocs/authentication/authentication_event.dart';
import 'package:certain/blocs/parameters/bloc.dart';

import 'package:certain/repositories/user_repository.dart';

import 'package:certain/views/constants.dart';
import 'package:certain/views/widgets/gender_widget.dart';

class ParametersForm extends StatefulWidget {
  final UserRepository _userRepository;

  ParametersForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _ParametersFormState createState() => _ParametersFormState();
}

class _ParametersFormState extends State<ParametersForm> {
  String interestedIn;
  File photo;
  ParametersBloc _parametersBloc;

  @override
  void initState() {
    _parametersBloc = BlocProvider.of<ParametersBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<ParametersBloc, ParametersState>(
      //cubit: _parametersBloc,
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Erreur lors de la mise à jour.'),
                    Icon(Icons.error)
                  ],
                ),
              ),
            );
        }
      },
      child: BlocBuilder<ParametersBloc, ParametersState>(
        builder: (context, state) {
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
                          FilePickerResult result = await FilePicker.platform
                              .pickFiles(type: FileType.image);
                          if (result != null) {
                            File getPic = File(result.files.single.path);
                            setState(() {
                              photo = getPic;
                            });
                            _parametersBloc.add(PhotoChanged(photo: photo));
                          }
                        },
                        child: photo == null
                            ? Image.asset('assets/profilephoto.png')
                            : CircleAvatar(
                                radius: size.width * 0.3,
                                backgroundImage: FileImage(photo),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Slider(
                      min: 18,
                      max: 55,
                      value: 19,
                      onChanged: (value) {
                        setState(() {});
                      }),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.02),
                        child: Text(
                          "Tu cherche:",
                          style: TextStyle(
                              color: Colors.white, fontSize: size.width * 0.09),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          genderWidget(FontAwesomeIcons.venus, "Female", size,
                              interestedIn, () {
                            setState(() {
                              interestedIn = "Female";
                            });
                          }),
                          genderWidget(
                              FontAwesomeIcons.mars, "Male", size, interestedIn,
                              () {
                            setState(() {
                              interestedIn = "Male";
                            });
                          }),
                          genderWidget(
                            FontAwesomeIcons.transgender,
                            "Transgender",
                            size,
                            interestedIn,
                            () {
                              setState(
                                () {
                                  interestedIn = "Transgender";
                                },
                              );
                            },
                          ),
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
        },
      ),
    );
  }
}
