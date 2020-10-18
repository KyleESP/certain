import 'package:flutter/material.dart';

import 'package:certain/helpers/constants.dart';

import 'package:certain/ui/pages/search.dart';
import 'package:certain/ui/pages/matches.dart';
import 'package:certain/ui/pages/messages.dart';
import 'package:certain/ui/pages/parameters.dart';

class Tabs extends StatelessWidget {
  final userId;

  const Tabs(this.userId);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: backgroundColor,
        accentColor: Colors.white,
      ),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              color: backgroundColor,
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    Expanded(child: Container()),
                    TabBar(
                      tabs: <Widget>[
                        Tab(icon: Icon(Icons.search)),
                        Tab(icon: Icon(Icons.people)),
                        Tab(icon: Icon(Icons.message)),
                        Tab(icon: Icon(Icons.supervised_user_circle))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Search(
                userId: userId,
              ),
              Matches(
                userId: userId,
              ),
              Messages(
                userId: userId,
              ),
              Parameters(
                userId: userId,
              )
            ],
          ),
        ),
      ),
    );
  }
}
