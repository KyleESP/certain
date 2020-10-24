import 'package:flutter/material.dart';
import 'package:certain/helpers/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/search/bloc.dart';

import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/search_repository.dart';
import 'package:certain/repositories/user_repository.dart';

import 'package:certain/ui/widgets/profile_widget.dart';
import 'package:certain/ui/pages/swap_card.dart';
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
  UserModel _user, _selectedUser;

  @override
  void initState() {
    _searchBloc = SearchBloc(_searchRepository, _userRepository);
    super.initState();
  }

  _likeUser() {
    _searchBloc.add(LikeUserEvent(
        currentUserId: widget.userId,
        selectedUserId: _selectedUser.uid,
        currentUserPhotoUrl: _user.photo,
        currentUserName: _user.name,
        selectedUserPhotoUrl: _selectedUser.photo,
        selectedUserName: _selectedUser.name));
  }

  _dislikeUser(UserModel user) {
    _searchRepository.dislikeUser(widget.userId, user.uid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<SearchBloc, SearchState>(
        cubit: _searchBloc,
        listener: (context, state) {
          if (state is HasMatchedState) {
            showDialog(
                context: context,
                builder: (context) {
                  Future.delayed(Duration(seconds: 3), () {
                    Navigator.pop(context);
                  });
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: profileWidget(
                      photo: _selectedUser.photo,
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
                          "Tu as matché avec " + _selectedUser.name + " !",
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
                return Stack(alignment: Alignment.center, children: <Widget>[
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
                  Positioned(
                    top: size.height * 0.05,
                    child: Text(
                      "Découvrir",
                      style: TextStyle(
                          color: Colors.white, fontSize: size.width * 0.06),
                    ),
                  ),
                  SwapCard(
                    demoProfiles: _usersToShow,
                    size: size,
                    myCallback: (decision, user) {
                      switch (decision) {
                        case Decision.like:
                          _selectedUser = user;
                          _likeUser();
                          break;
                        case Decision.nope:
                          _dislikeUser(user);
                          break;
                        default:
                          break;
                      }
                    },
                  ),
                ]);
              }
            } else
              return Container();
          },
        ));
  }
}
