import 'package:certain/helpers/constants.dart';
import 'package:certain/helpers/functions.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:certain/blocs/matches/bloc.dart';

import 'package:certain/models/user_model.dart';
import 'package:certain/repositories/matches_repository.dart';

import 'package:certain/ui/widgets/icon_widget.dart';
import 'package:certain/ui/widgets/profile_widget.dart';
import 'package:certain/ui/widgets/user_gender_widget.dart';
import 'package:certain/ui/pages/play_mcq.dart';

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

  @override
  void initState() {
    _matchesBloc = MatchesBloc(_matchesRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<MatchesBloc, MatchesState>(
      cubit: _matchesBloc,
      builder: (BuildContext context, MatchesState state) {
        if (state is LoadingState) {
          _matchesBloc.add(LoadCurrentUserEvent(userId: widget.userId));
          return CircularProgressIndicator();
        }
        if (state is LoadCurrentUserState) {
          currentUser = state.currentUser;
          _matchesBloc.add(LoadListsEvent(userId: widget.userId));
          return CircularProgressIndicator();
        }
        if (state is LoadUserState) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                title: Text(
                  "Matched User",
                  style: TextStyle(color: Colors.black, fontSize: 30.0),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: state.matchedList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  }
                  if (snapshot.data.docs != null) {
                    final matchedUsers = snapshot.data.docs;

                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          var user = matchedUsers[index];
                          return GestureDetector(
                            onTap: () async {
                              UserModel selectedUser = await _matchesRepository
                                  .getUserDetails(user.id);
                              distance =
                                  await getDistance(selectedUser.location);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: profileWidget(
                                    photo: selectedUser.photo,
                                    photoHeight: size.height,
                                    padding: size.height * 0.01,
                                    photoWidth: size.width,
                                    clipRadius: size.height * 0.01,
                                    containerWidth: size.width,
                                    containerHeight: size.height * 0.2,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.height * 0.02),
                                      child: ListView(
                                        children: <Widget>[
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
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
                                                          size.height * 0.05),
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
                                                distance != null
                                                    ? distance.toString() +
                                                        " km"
                                                    : "Distance inconnue",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.all(
                                                    size.width * 0.01),
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
                                                child: iconWidget(Icons.clear,
                                                    () {
                                                  _matchesBloc.add(
                                                      RemoveMatchEvent(
                                                          currentUser:
                                                              widget.userId,
                                                          selectedUser:
                                                              user.id));
                                                  matchedUsers.remove(user);
                                                  Navigator.pop(context);
                                                }, size.height * 0.07,
                                                    dislikeButton),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(
                                                    size.height * 0.01),
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
                                                child: iconWidget(Icons.message,
                                                    () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return PlayMcq(
                                                          user: currentUser,
                                                          selectedUser:
                                                              selectedUser);
                                                    },
                                                  ));
                                                }, size.height * 0.04,
                                                    Colors.blue),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: profileWidget(
                              padding: size.height * 0.01,
                              photo: user.data()['photoUrl'],
                              photoWidth: size.width * 0.5,
                              photoHeight: size.height * 0.3,
                              clipRadius: size.height * 0.01,
                              containerHeight: size.height * 0.03,
                              containerWidth: size.width * 0.5,
                              child: Text(
                                "  " + user.data()['name'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        childCount: matchedUsers.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  }
                },
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
