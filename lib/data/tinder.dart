import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:like_button/like_button.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:tinder/data/profile.dart';

import '/../models/joke.dart';

class TinderPage extends StatefulWidget {
  const TinderPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TinderPage> createState() => Tinder();
}

class Tinder extends State<TinderPage> {
  String _imageUrl = "https://pbs.twimg.com/profile_images/1407346896/89.jpg";
  String _jokeString =
      "Chuck Norris is the only person that can punch a cyclops between the eye.";
  int _fontSize = 26;
  int _likeCount = 0;
  int _favCount = 0;

  final dio = Dio();

  Future<Joke> fetchJoke() async {
    Response response;

    if (chosenCategory == 'any') {
      response = await dio.get("https://api.chucknorris.io/jokes/random");
    } else {
      response = await dio.get(
          "https://api.chucknorris.io/jokes/random?category=$chosenCategory");
    }

    return Joke.fromJson(response.data);
  }

  Future<String> getImageFromText(String? text) async {
    dio.options.headers["api-key"] = "c9b23ba8-68d9-4a35-b219-31d929a01bd5";
    final response = await dio
        .post("https://api.deepai.org/api/text2img", data: {"text": text});
    final imageMap = jsonDecode(response.toString());
    return imageMap["output_url"] as String;
  }

  Future<bool> _addFav(bool isLiked) async {
    isLiked ? --_favCount : ++_favCount;

    return !isLiked;
  }

  Future<bool> _setJoke(bool isLiked) async {
    final joke = await fetchJoke();
    String jokeString = joke.value;

    getImageFromText(jokeString).then((url) {
      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() {
          if (joke.value.length > 1 && joke.value.length < 80) {
            _fontSize = 30;
          } else if (joke.value.length > 80 && joke.value.length < 130) {
            _fontSize = 26;
          } else if (joke.value.length > 130 && joke.value.length < 160) {
            _fontSize = 24;
          } else if (joke.value.length > 160 && joke.value.length < 200) {
            _fontSize = 21;
          } else if (joke.value.length > 200) {
            _fontSize = 18;
          }

          _imageUrl = url;
          _jokeString = jokeString;
        });
      });
    });

    ++_likeCount;

    return !isLiked;
  }

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

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      DropShadowImage(
                        borderRadius: 10,
                        blurRadius: 10,
                        offset: const Offset(5, 5),
                        scale: 1,
                        image: Image.network(
                          _imageUrl,
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height * 0.35,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
                        child: Text(
                          _jokeString,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'VK Sans',
                            fontSize: _fontSize.toDouble(),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        LikeButton(
                            onTap: _setJoke,
                            size: 75,
                            likeCount: 0,
                            countPostion: CountPostion.bottom,
                            countBuilder:
                                (int? count, bool isLiked, String text) {
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueGrey,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    "$_likeCount"),
                              );
                            }),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.15,
                          ),
                          child: LikeButton(
                              onTap: _addFav,
                              likeCount: 0,
                              countPostion: CountPostion.bottom,
                              size: 75,
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: Color(0xfff5bf42),
                                dotSecondaryColor: Color(0xffcce046),
                              ),
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.star,
                                  size: 75,
                                  color: isLiked ? Colors.yellow : Colors.grey,
                                );
                              },
                              countBuilder:
                                  (int? count, bool isLiked, String text) {
                                return Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.blueGrey,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      "$_favCount"),
                                );
                              }),
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
