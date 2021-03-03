
import 'package:flutter/material.dart';
import 'package:myfarm_app/Screens/SplashScreen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      //debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }

}

