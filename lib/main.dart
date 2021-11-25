import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//pages
import './pages/home.dart';
import './pages/status.dart';
//providers
import './services/socket_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: MaterialApp(
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
          'status': (_) => StatusPage(),
        },
      ),
    );
  }
}
