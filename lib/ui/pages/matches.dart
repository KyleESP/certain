import 'package:certain/helpers/constants.dart';
import 'package:certain/ui/pages/play_mcq.dart';
import 'package:certain/ui/widgets/loader_widget.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/matches/bloc.dart';

import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/matches_repository.dart';

import 'package:certain/ui/widgets/icon_widget.dart';
import 'package:certain/ui/widgets/profile_widget.dart';
import 'package:certain/ui/widgets/user_gender_widget.dart';
import 'package:certain/ui/widgets/photo_widget.dart';

class Matches extends StatefulWidget {
  final String userId;

  const Matches({this.userId});

  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  MatchesRepository _matchesRepository = MatchesRepository();
  MatchesBloc _matchesBloc;
  double distance;
  UserModel currentUser;
  var matchedUsers;

  @override
  void initState() {
    _matchesBloc = MatchesBloc(_matchesRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<MatchesBloc, MatchesState>(
        cubit: _matchesBloc,
        listener: (context, state) {
          if (state is IsSelectedState) {
            UserModel selectedUser = state.selectedUser;
            showDialog(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                      backgroundColor: Colors.transparent,
                      children: <Widget>[
                        Column(
                          //alignment: Alignment.center,
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Positioned(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0)),
                                    child: Container(
                                      width: size.width,
                                      height: size.height * 0.55,
                                      child: PhotoWidget(
                                        photoLink: selectedUser.photo,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: size.height * 0.03),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black54,
                                            Colors.black87,
                                            Colors.black
                                          ],
                                          stops: [
                                            0.1,
                                            0.2,
                                            0.4,
                                            0.9
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter),
                                      color: Colors.black45,
                                    ),
                                    width: size.width,
                                    height: size.height * 0.13,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.height * 0.02),
                                      child: ListView(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              userGender(selectedUser.gender),
                                              Expanded(
                                                child: Text(
                                                  " " +
                                                      selectedUser.name +
                                                      ", " +
                                                      selectedUser.age
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          size.height * 0.03),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                selectedUser.distance != null
                                                    ? selectedUser.distance
                                                            .toString() +
                                                        " km"
                                                    : "Distance inconnue",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.height * 0.02,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: size.height * 0.12,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(size.width * 0.01),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: Offset(0.0, 5.0),
                                        ),
                                      ],
                                    ),
                                    child: iconWidget(Icons.clear, () {
                                      _matchesBloc.add(RemoveMatchEvent(
                                          currentUser: widget.userId,
                                          selectedUser: selectedUser.uid));
                                      matchedUsers.removeAt(state.index);
                                      Navigator.pop(context);
                                    }, size.height * 0.06, dislikeButton),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.all(size.height * 0.015),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: Offset(0.0, 5.0),
                                        ),
                                      ],
                                    ),
                                    child: iconWidget(Icons.message, () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return PlayMcq(
                                              user: currentUser,
                                              selectedUser: selectedUser);
                                        },
                                      ));
                                    }, size.height * 0.045, likeButton),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ));
          }
        },
        child: BlocBuilder<MatchesBloc, MatchesState>(
          cubit: _matchesBloc,
          builder: (BuildContext context, MatchesState state) {
            if (state is LoadingState) {
              _matchesBloc.add(LoadCurrentUserEvent(userId: widget.userId));
              return loaderWidget();
            }
            if (state is LoadCurrentUserState) {
              currentUser = state.currentUser;
              _matchesBloc.add(LoadListsEvent(userId: widget.userId));
              return loaderWidget();
            }
            if (state is LoadUserState) {
              return Stack(alignment: Alignment.center, children: <Widget>[
                Positioned(
                  top: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(200.0, 100.0),
                        bottomRight: Radius.elliptical(200.0, 100.0)),
                    child: Container(
                      height: size.height * 0.25,
                      width: size.width,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        gradient: gradient,
                      ),
                    ),
                  ),
                ),
                CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      pinned: true,
                      centerTitle: true,
                      title: Text(
                        "Vos matchs",
                        style: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.03),
                      ),
                      backgroundColor: Colors.transparent,
                      toolbarHeight: size.height * 0.12,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: state.matchedList,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SliverToBoxAdapter(
                            child: Container(),
                          );
                        }
                        if (snapshot.data.docs.isNotEmpty) {
                          matchedUsers = snapshot.data.docs;
                          return SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                QueryDocumentSnapshot user =
                                    matchedUsers[index];
                                return Container(
                                    margin: EdgeInsets.only(
                                        left: size.width * 0.04,
                                        right: size.width * 0.04),
                                    child: GestureDetector(
                                      onTap: () {
                                        _matchesBloc.add(
                                            SelectedUserEvent(user.id, index));
                                      },
                                      child: profileWidget(
                                        padding: size.height * 0.01,
                                        photo: user.data()['photoUrl'],
                                        photoWidth: size.width * 0.5,
                                        photoHeight: size.height * 0.2,
                                        clipRadius: size.height * 0.01,
                                        containerHeight: size.height * 0.04,
                                        containerWidth: size.width * 0.5,
                                        child: Text(
                                          "  " + user.data()['name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height * 0.023,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                              childCount: matchedUsers.length,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                          );
                        } else {
                          return SliverToBoxAdapter(
                            child: SizedBox(
                              height: size.height * 0.7,
                              child: Center(
                                child: Text(
                                  "Vous n'avez pas de matchs pour le moment !",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: size.height * 0.023,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                )
              ]);
            }
            return Container();
          },
        ));
  }
}
