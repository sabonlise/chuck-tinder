import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:like_button/like_button.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FavoritesPage> createState() => Favorites();
}

class Favorites extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(
              fontFamily: 'VK Sans',
              fontSize: 22,
              fontStyle: FontStyle.normal,
            )),
        centerTitle: true,
      ),
      body: const Text("123"),
    );
  }
}
