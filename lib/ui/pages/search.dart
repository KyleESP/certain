import 'package:certain/helpers/constants.dart';
import 'package:certain/ui/widgets/card_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/search/bloc.dart';

import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/search_repository.dart';
import 'package:certain/repositories/user_repository.dart';

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
  bool _lastReached;

  @override
  void initState() {
    _lastReached = false;
    _searchBloc = SearchBloc(_searchRepository, _userRepository);
    super.initState();
  }

  _likeUser() async {
    bool hasMatched = await _searchRepository.likeUser(
        widget.userId,
        _selectedUser.uid,
        _user.name,
        _user.photo,
        _selectedUser.name,
        _selectedUser.photo);

    if (hasMatched) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CardWidget(_selectedUser)),
      );
    }
  }

  _dislikeUser() {
    _searchRepository.dislikeUser(widget.userId, _selectedUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<SearchBloc, SearchState>(
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
          if (_usersToShow.isEmpty || _lastReached) {
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
                myCallback: (decision, user, lastReached) {
                  _selectedUser = user;
                  switch (decision) {
                    case Decision.like:
                      _likeUser();
                      break;
                    case Decision.nope:
                      _dislikeUser();
                      break;
                    default:
                      break;
                  }
                  if (lastReached) {
                    setState(() {
                      _lastReached = lastReached;
                    });
                  }
                },
              ),
            ]);
          }
        } else
          return Container();
      },
    );
  }
}
