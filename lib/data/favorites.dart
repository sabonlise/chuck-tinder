import 'package:flutter/material.dart';
import '../models/joke.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key, required this.title, required this.jokes})
      : super(key: key);

  final String title;
  final List<Joke> jokes;

  @override
  Widget build(BuildContext context) {
    if (jokes.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            title: Text(title,
                style: const TextStyle(
                  fontFamily: 'VK Sans',
                  fontSize: 22,
                  fontStyle: FontStyle.normal,
                )),
            centerTitle: true,
          ),
          body: const Center(
            child: Text("You don't have any favorite jokes yet",
                style: TextStyle(
                  fontFamily: 'VK Sans',
                  fontSize: 22,
                  fontStyle: FontStyle.normal,
                )),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(title,
                style: const TextStyle(
                  fontFamily: 'VK Sans',
                  fontSize: 22,
                  fontStyle: FontStyle.normal,
                )),
            centerTitle: true,
          ),
          body: ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                        title: Text(jokes[index].value),
                        leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(jokes[index].image))));
              }));
    }
  }
}
