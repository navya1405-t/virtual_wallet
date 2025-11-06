import 'package:flutter/material.dart';
import 'package:virtual_wallet/screens/cardsHub.dart';
import 'package:virtual_wallet/screens/home.dart';
import 'package:virtual_wallet/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 196, 87, 154),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:
          //HomeScreen(username: 'Navya'),
          loginScreen(),
    );
  }
}
