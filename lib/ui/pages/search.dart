import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/search/bloc.dart';

import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/search_repository.dart';
import 'package:certain/repositories/user_repository.dart';

import 'package:certain/ui/pages/swap_card.dart';
import 'package:certain/ui/widgets/match_card_widget.dart';
import 'package:certain/ui/widgets/loader_widget.dart';

import 'package:certain/helpers/constants.dart';

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
      Image userImage = Image.network(_user.photo, fit: BoxFit.cover);
      Completer<ImageInfo> completer = Completer();

      userImage.image
          .resolve(new ImageConfiguration())
          .addListener(ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info);
      }));
      await completer.future;

      if (mounted) {
        completer = Completer();
        Image selectedUserImage =
            new Image.network(_selectedUser.photo, fit: BoxFit.cover);
        selectedUserImage.image
            .resolve(new ImageConfiguration())
            .addListener(ImageStreamListener((ImageInfo info, bool _) {
          completer.complete(info);
        }));
        await completer.future;

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchCardWidget(
                  user: _user,
                  selectedUser: _selectedUser,
                  userImage: userImage,
                  selectedUserImage: selectedUserImage),
            ),
          );
        }
      }
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
          return Stack(alignment: Alignment.topCenter, children: <Widget>[
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
              top: size.height * 0.06,
              child: Text(
                "Découvrir",
                style:
                    TextStyle(color: Colors.white, fontSize: size.width * 0.06),
              ),
            ),
            if (_usersToShow.isEmpty || _lastReached)
              Positioned(
                top: size.height * 0.5,
                left: size.width * 0.1,
                right: size.width * 0.1,
                child: Text(
                  "Nous n'avons trouvé personne correspondant à vos attentes...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: size.height * 0.023,
                      fontWeight: FontWeight.w500),
                ),
              ),
            if (_usersToShow.isNotEmpty && !_lastReached)
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
        } else
          return Container();
      },
    );
  }
}
