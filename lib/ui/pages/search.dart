import 'package:flutter/material.dart';
import 'package:certain/helpers/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:certain/blocs/search/bloc.dart';

import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/search_repository.dart';
import 'package:certain/repositories/user_repository.dart';

import 'package:certain/ui/widgets/icon_widget.dart';
import 'package:certain/ui/widgets/profile_widget.dart';
import 'package:certain/ui/widgets/user_gender_widget.dart';
import 'package:certain/ui/widgets/loader_widget.dart';

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
  List<UserModel> _usersToShow = [];
  UserModel _user, _currentUser;

  @override
  void initState() {
    _searchBloc = SearchBloc(_searchRepository, _userRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<SearchBloc, SearchState>(
        cubit: _searchBloc,
        listener: (context, state) {
          if (state.hasMatched) {
            showDialog(
                context: context,
                builder: (context) {
                  Future.delayed(Duration(seconds: 3), () {
                    Navigator.pop(context);
                  });
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: profileWidget(
                      photo: _currentUser.photo,
                      photoHeight: size.height,
                      padding: size.height * 0.01,
                      photoWidth: size.width,
                      clipRadius: size.height * 0.01,
                      containerWidth: size.width,
                      containerHeight: size.height * 0.2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.02),
                        child: Text(
                          "Tu as matché avec " + _currentUser.name + " !",
                          style: TextStyle(
                              color: Colors.red, fontSize: size.height * 0.02),
                        ),
                      ),
                    ),
                  );
                });
          }
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          cubit: _searchBloc,
          builder: (context, state) {
            if (state is InitialSearchState) {
              _searchBloc.add(
                LoadUserEvent(),
              );
              return loaderWidget();
            }
            if (state is LoadingState) {
              return loaderWidget();
            }
            if (state is LoadUserState) {
              _user = state.user;
              _usersToShow = state.usersToShow;
              if (_usersToShow.isNotEmpty) {
                _currentUser = _usersToShow[0];
              }
              _searchBloc.add(
                LoadCurrentUserEvent(),
              );
            }
            if (state is LoadCurrentUserState) {
              if (_usersToShow.isEmpty) {
                return Text(
                  "Il n'y a aucune personne",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                );
              } else {
                _currentUser = _usersToShow[0];
                return Stack(children: <Widget>[
                  Positioned(
                    top: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(200.0, 140.0),
                          bottomRight: Radius.elliptical(200.0, 140.0)),
                      child: Container(
                        height: size.height * 0.35,
                        width: size.width,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          gradient: gradient,
                        ),
                      ),
                    ),
                  ),
                  profileWidget(
                    padding: size.height * 0.035,
                    photoHeight: size.height * 0.63,
                    photoWidth: size.width * 0.85,
                    photo: _currentUser.photo,
                    clipRadius: size.height * 0.02,
                    containerHeight: size.height * 0.25,
                    containerWidth: size.width * 0.85,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.02),
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
                                      _currentUser.age.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.03),
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
                                _currentUser.distance != null
                                    ? _currentUser.distance.toString() + " km"
                                    : "Distance inconnue",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.0, 0.9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(size.width * 0.01),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300],
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(5.0, 5.0),
                              ),
                            ],
                          ),
                          child: iconWidget(Icons.clear, () {
                            _usersToShow.remove(_currentUser);
                            _searchBloc.add(DislikeUserEvent(
                                widget.userId, _currentUser.uid));
                          }, size.height * 0.07, dislikeButton),
                        ),
                        Container(
                          padding: EdgeInsets.all(size.width * 0.03),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300],
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(5.0, 5.0),
                              ),
                            ],
                          ),
                          child: iconWidget(FontAwesomeIcons.solidHeart, () {
                            _usersToShow.remove(_currentUser);
                            _searchBloc.add(LikeUserEvent(
                                currentUserId: widget.userId,
                                selectedUserId: _currentUser.uid,
                                currentUserPhotoUrl: _user.photo,
                                currentUserName: _user.name,
                                selectedUserPhotoUrl: _currentUser.photo,
                                selectedUserName: _currentUser.name));
                          }, size.height * 0.05, likeButton),
                        ),
                      ],
                    ),
                  )
                ]);
              }
            } else
              return Container();
          },
        ));
  }
}
