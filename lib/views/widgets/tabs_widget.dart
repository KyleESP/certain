import 'package:flutter/material.dart';

import '../constants.dart';

import 'package:certain/views/pages/search.dart';
import 'package:certain/views/pages/messages.dart';
import 'package:certain/views/pages/parameters.dart';

class Tabs extends StatelessWidget {
  final userId;

  const Tabs({this.userId});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: backgroundColor,
        accentColor: Colors.white,
      ),
      child: DefaultTabController(
        length: 3,
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
                        Tab(icon: Icon(Icons.message)),
                        Tab(icon: Icon(Icons.supervised_user_circle)),
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
              Messages(
                userId: userId,
              ),
              Parameters(
                userId: userId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
