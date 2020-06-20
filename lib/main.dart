import 'package:flutter/material.dart';
import 'package:indian_news/src/home/home_news.dart';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Indian Headlines'),
    );
  }
}

