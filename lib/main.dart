import 'package:flutter/material.dart';

//pages
import './pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.red,
      ),
      title: 'Material App',
      initialRoute: 'home',
      home: HomePage(),
      routes: {
        'home': (_) => HomePage(),
      },
    );
  }
}
