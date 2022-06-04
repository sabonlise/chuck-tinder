import 'package:flutter/material.dart';

import 'data/profile.dart';
import 'data/tinder.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
       title: 'Tinder with Chuck',
       theme: ThemeData(
         primarySwatch: Colors.pink,
         fontFamily: 'VK Sans',
       ),

       home: const MyHomePage(title: 'Tinder with Chuck'),
       debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;
  final tinder = const TinderPage(title: "Tinder with Chuck");
  final profile = const ProfilePage(title: "My profile");

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          tinder,
          profile
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'tinder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'my profile',
          ),
        ],
        selectedItemColor: Colors.pinkAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

