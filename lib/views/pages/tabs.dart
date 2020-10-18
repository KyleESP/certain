import 'package:flutter/material.dart';

import 'package:certain/helpers/constants.dart';

import 'package:certain/views/pages/search.dart';
import 'package:certain/views/pages/matches.dart';
import 'package:certain/views/pages/messages.dart';
import 'package:certain/views/pages/parameters.dart';

class BottomTab extends StatefulWidget {
  final userId;

  const BottomTab({this.userId});

  @override
  _BottomTabState createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  int _selectedIndex = 0;

  _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return Search(userId: widget.userId);
      case 1:
        return Matches(userId: widget.userId);
      case 2:
        return Messages(userId: widget.userId);
      case 3:
        return Parameters(userId: widget.userId);

      default:
        return new Text("");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _getSelectedPage(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30.0,
        selectedItemColor: loginButtonColor,
        unselectedIconTheme: IconThemeData(
          size: 25.0,
          color: Colors.grey[400],
        ) ,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Recherche'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Matchs'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Chat'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            title: Text('Paramètres'),
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
