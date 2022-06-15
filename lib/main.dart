import 'dart:async';

import 'package:flutter/material.dart';

import 'data/profile.dart';
import 'data/tinder.dart';
import 'data/favorites.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'VK Sans',
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.normal,
              color: Colors.white),
          headline2: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.normal,
              color: Colors.white),
          headline3: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.normal,
              color: Colors.black),
          headline4: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
          headline6: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
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
  int _selectedIndex = 1;
  final tinder = const TinderPage(title: "Tinder with Chuck");
  final profile = const ProfilePage(title: "My profile");
  var favorites = FavoritesPage(title: "Favorite jokes", jokes: jokes);

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        favorites = FavoritesPage(title: "Favorite jokes", jokes: jokes);
      }
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[profile, tinder, favorites],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'my profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'tinder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_purple500),
            label: 'favorites',
          ),
        ],
        selectedItemColor: Colors.pinkAccent,
        selectedIconTheme:
            const IconThemeData(color: Colors.pinkAccent, size: 30),
        onTap: _onItemTapped,
      ),
    );
  }
}
