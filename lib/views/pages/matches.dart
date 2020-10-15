import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:certain/blocs/matches/bloc.dart';

import 'package:certain/models/my_user.dart';
import 'package:certain/repositories/matches_repository.dart';

import 'package:certain/views/widgets/icon_widget.dart';
import 'package:certain/views/widgets/page_turn_widget.dart';
import 'package:certain/views/widgets/profile_widget.dart';
import 'package:certain/views/widgets/user_gender_widget.dart';

import 'messaging.dart';

class Matches extends StatefulWidget {
  final String userId;

  const Matches({this.userId});

  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  MatchesRepository matchesRepository = MatchesRepository();
  MatchesBloc _matchesBloc;

  int difference;

  getDifference(GeoPoint userLocation) async {
    Position position = await getCurrentPosition();

    double location = distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);

    difference = location.toInt();
  }

  @override
  void initState() {
    _matchesBloc = MatchesBloc(matchesRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<MatchesBloc, MatchesState>(
      cubit: _matchesBloc,
      builder: (BuildContext context, MatchesState state) {
        if (state is LoadingState) {
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
                    final user = snapshot.data.docs;

                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              MyUser selectedUser = await matchesRepository
                                  .getUserDetails(user[index].id);
                              MyUser currentUser = await matchesRepository
                                  .getUserDetails(widget.userId);
                              await getDifference(selectedUser.location);
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
                                                      (DateTime.now().year -
                                                              selectedUser
                                                                  .birthdate
                                                                  .toDate()
                                                                  .year)
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
                                                difference != null
                                                    ? (difference / 1000)
                                                            .floor()
                                                            .toString() +
                                                        " km away"
                                                    : "away",
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
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    size.height * 0.02),
                                                child: iconWidget(Icons.message,
                                                    () {
                                                  _matchesBloc.add(
                                                    OpenChatEvent(
                                                        currentUser:
                                                            widget.userId,
                                                        selectedUser:
                                                            selectedUser.uid),
                                                  );
                                                  pageTurn(
                                                      Messaging(
                                                          currentUser:
                                                              currentUser,
                                                          selectedUser:
                                                              selectedUser),
                                                      context);
                                                }, size.height * 0.04,
                                                    Colors.white),
                                              ),
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
                              photo: user[index].data()['photoUrl'],
                              photoWidth: size.width * 0.5,
                              photoHeight: size.height * 0.3,
                              clipRadius: size.height * 0.01,
                              containerHeight: size.height * 0.03,
                              containerWidth: size.width * 0.5,
                              child: Text(
                                "  " + user[index].data()['name'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        childCount: user.length,
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
