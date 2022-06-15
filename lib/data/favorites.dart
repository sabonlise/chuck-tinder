import 'package:flutter/material.dart';
import '../models/joke.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key, required this.title, required this.jokes})
      : super(key: key);

  final String title;
  final List<Joke> jokes;

  @override
  State<FavoritesPage> createState() => Favorites();
}

class Favorites extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.jokes.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title,
                style: Theme.of(context).textTheme.headline2),
            centerTitle: true,
          ),
          body: Center(
              child: Padding(
            padding: const EdgeInsets.all(35),
            child: Text(
              "You don't have any favorite jokes yet",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          )));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title,
                style: Theme.of(context).textTheme.headline1),
            centerTitle: true,
          ),
          body: ListView.builder(
              itemCount: widget.jokes.length,
              itemBuilder: (context, index) {
                final joke = widget.jokes[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      setState(() {
                        widget.jokes.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Joke with Chuck Norris"
                              " was not deleted.\nChuck Norris deleted you",
                              style: Theme.of(context).textTheme.headline6)));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "You can't hide from"
                              " Chuck Norris",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.apply(fontStyle: FontStyle.italic))));
                    }
                  },
                  background: Container(
                      color: Colors.lightGreen,
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: const [
                              Icon(Icons.hide_source, color: Colors.black),
                              Text('Hide joke')
                            ],
                          ))),
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(Icons.delete_forever_rounded,
                              color: Colors.white),
                          Text('Delete joke',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  child: Card(
                      child: ListTile(
                          title: Text(
                            joke.value,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(joke.image),
                              radius: 40))),
                );
              }));
    }
  }
}
