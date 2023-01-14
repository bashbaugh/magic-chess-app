import 'package:chessapp/main_page.dart';
import 'package:flutter/material.dart';
import 'chess_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Magic Chess',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // initialRoute: '/load',
        // routes: <String, WidgetBuilder>{
        //   '/load': (BuildContext context) => const AppLoadPage(),
        //   '/': (BuildContext context) => const MainPage(),
        // });
        home: const MainPage());
  }
}

class AppLoadPage extends StatefulWidget {
  const AppLoadPage({super.key});

  @override
  State<AppLoadPage> createState() => _AppLoadPageState();
}

class _AppLoadPageState extends State<AppLoadPage> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/');
    });
    return const Scaffold(body: Center(child: Text('Loading...')));
  }
}
