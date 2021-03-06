import 'package:flutter/material.dart';

import 'package:certain/helpers/constants.dart';

import 'package:certain/ui/pages/search.dart';
import 'package:certain/ui/pages/matches.dart';
import 'package:certain/ui/pages/messages.dart';
import 'package:certain/ui/pages/settings.dart';

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
        return Settings(userId: widget.userId);
      default:
        return Container();
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
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Recherche'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Matchs'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Chat'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Paramètres'),
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
