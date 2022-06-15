import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:like_button/like_button.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:tinder/data/profile.dart';

import '/../models/joke.dart';

List<Joke> jokes = [];

class TinderPage extends StatefulWidget {
  const TinderPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TinderPage> createState() => Tinder();
}

class Tinder extends State<TinderPage> {
  Joke currentJoke = Joke(
      "Chuck Norris is the only person that can punch a cyclops between the eye.",
      "",
      "https://pbs.twimg.com/profile_images/1407346896/89.jpg");

  double _fontSizeFactor = 1;

  final dio = Dio();

  Future<Joke> fetchJoke() async {
    Response response;
    try {
      if (chosenCategory == 'any') {
        response = await dio.get("https://api.chucknorris.io/jokes/random");
      } else {
        response = await dio.get(
            "https://api.chucknorris.io/jokes/random?category=$chosenCategory");
      }
      var parsed = Map<String, dynamic>.from(response.data);
      var imageUrl = await getImageFromText(parsed["value"]);
      parsed["image"] = imageUrl;

      return Joke.fromJson(parsed);
    } catch (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);

      return currentJoke;
    }
  }

  Future<String> getImageFromText(String? text) async {
    try {
      dio.options.headers["api-key"] = "c9b23ba8-68d9-4a35-b219-31d929a01bd5";
      final response = await dio
          .post("https://api.deepai.org/api/text2img", data: {"text": text});
      final imageMap = jsonDecode(response.toString());
      return imageMap["output_url"] as String;
    } catch (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);

      return currentJoke.image;
    }
  }

  Future<bool> _addFav(bool isLiked) async {
    isLiked ? jokes.remove(currentJoke) : jokes.add(currentJoke);

    return !isLiked;
  }

  Future<bool> _setJoke(bool isLiked) async {
    fetchJoke().then((joke) {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          if (joke.value.length > 1 && joke.value.length < 80) {
            _fontSizeFactor = 1.15;
          } else if (joke.value.length > 80 && joke.value.length < 130) {
            _fontSizeFactor = 1;
          } else if (joke.value.length > 130 && joke.value.length < 160) {
            _fontSizeFactor = 0.92;
          } else if (joke.value.length > 160 && joke.value.length < 200) {
            _fontSizeFactor = 0.8;
          } else if (joke.value.length > 200) {
            _fontSizeFactor = 0.69;
          }

          currentJoke = joke;
        });
      });
    });

    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: Theme.of(context).textTheme.headline2),
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
                          currentJoke.image,
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
                          currentJoke.value,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline3?.apply(
                                color: Colors.grey,
                                fontSizeFactor: _fontSizeFactor,
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
                            countPostion: CountPostion.bottom),
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.15,
                          ),
                          child: LikeButton(
                            onTap: _addFav,
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
                          ),
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
