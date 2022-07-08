import 'package:flutter/material.dart';

import 'home_view.dart';

// TODO: make a bot which can play the wordle game by itself by taking input about a guess
// then the user won't have to type anything, they just mark wether something is correct or not
// that's also more like bot development and user isn't doing much
// so that can be a separate project which uses a common solver logic.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Wordaily Solver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
