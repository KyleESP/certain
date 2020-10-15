import 'package:certain/views/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:certain/blocs/search/bloc.dart';

import 'package:certain/models/my_user.dart';
import 'package:certain/repositories/search_repository.dart';
import 'package:certain/repositories/user_repository.dart';

import 'package:certain/views/widgets/icon_widget.dart';
import 'package:certain/views/widgets/profile_widget.dart';
import 'package:certain/views/widgets/user_gender_widget.dart';

class Search extends StatefulWidget {
  final String userId;

  const Search({this.userId});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final SearchRepository _searchRepository = SearchRepository();
  final UserRepository _userRepository = UserRepository();
  SearchBloc _searchBloc;
  MyUser _user, _currentUser;
  int difference;

  getDifference(GeoPoint userLocation) async {
    Position position = await getCurrentPosition();

    double location = distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);

    difference = location.toInt();
  }

  @override
  void initState() {
    _searchBloc = SearchBloc(_searchRepository, _userRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<SearchBloc, SearchState>(
      cubit: _searchBloc,
      builder: (context, state) {
        if (state is InitialSearchState) {
          _searchBloc.add(
            LoadUserEvent(userId: widget.userId),
          );
          return loaderWidget();
        }
        if (state is LoadingState) {
          return loaderWidget();
        }
        if (state is LoadUserState) {
          _user = state.user;
          _searchBloc.add(
            LoadCurrentUserEvent(userId: widget.userId),
          );
        }
        if (state is HasMatchedState) {
          print("Tu as matché avec " +
              _currentUser.name +
              " (id = " +
              _currentUser.uid +
              ") et sa photo est " +
              _currentUser.photo);
        }
        if (state is LoadCurrentUserState) {
          _currentUser = state.currentUser;

          getDifference(_currentUser.location);
          if (_currentUser.location == null) {
            return Text(
              "Il n'y a aucune personne",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            );
          } else
            return profileWidget(
              padding: size.height * 0.035,
              photoHeight: size.height * 0.824,
              photoWidth: size.width * 0.95,
              photo: _currentUser.photo,
              clipRadius: size.height * 0.02,
              containerHeight: size.height * 0.3,
              containerWidth: size.width * 0.9,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                    Row(
                      children: <Widget>[
                        userGender(_currentUser.gender),
                        Expanded(
                          child: Text(
                            " " +
                                _currentUser.name +
                                ", " +
                                (DateTime.now().year -
                                        _currentUser.birthdate.toDate().year)
                                    .toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.05),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        Text(
                          difference != null
                              ? "A " +
                                  (difference / 1000).floor().toString() +
                                  " km"
                              : "Distance inconnue",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        iconWidget(Icons.clear, () {
                          _searchBloc.add(
                              DislikeUserEvent(widget.userId, _currentUser.uid));
                        }, size.height * 0.08, Colors.blue),
                        iconWidget(FontAwesomeIcons.solidHeart, () {
                          _searchBloc.add(LikeUserEvent(
                              currentUserId: widget.userId,
                              selectedUserId: _currentUser.uid,
                              currentUserPhotoUrl: _user.photo,
                              currentUserName: _user.name,
                              selectedUserPhotoUrl: _currentUser.photo,
                              selectedUserName: _currentUser.name));
                        }, size.height * 0.06, Colors.red)
                      ],
                    )
                  ],
                ),
              ),
            );
        } else
          return Container();
      },
    );
  }
}
