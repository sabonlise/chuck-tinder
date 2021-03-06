import 'package:flutter/material.dart';

String name = 'Oleg';
String chosenCategory = 'any';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ProfilePage> createState() => Profile();
}

class Profile extends State<ProfilePage> {
  String? text;

  List<String> categories = [
    'any',
    'animal',
    'career',
    'celebrity',
    'dev',
    'explicit',
    'fashion',
    'food',
    'history',
    'money',
    'movie',
    'music',
    'political',
    'religion',
    'science',
    'sport',
    'travel'
  ];

  void _setText() {
    setState(() {
      name = text!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextField(
            style: Theme.of(context).textTheme.headline3,
            decoration: const InputDecoration(
              hintText: 'Oleg',
              labelText: 'Your name',
            ),
            onChanged: (value) => text = value,
          ),
        ),
        DropdownButton<String>(
          value: chosenCategory,
          icon: const Icon(Icons.category_outlined),
          underline: Container(
            height: 2,
            color: Colors.pink,
          ),
          onChanged: (String? newValue) {
            setState(() {
              chosenCategory = newValue!;
            });
          },
          items: categories.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                style: Theme.of(context).textTheme.headline3,
                value,
              ),
            );
          }).toList(),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            height: 40,
            width: 120,
            child: ElevatedButton(
              onPressed: _setText,
              child: Text(
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      ?.apply(color: Colors.white),
                  'Save'),
            ),
          ),
        ),
      ])),
    );
  }
}
