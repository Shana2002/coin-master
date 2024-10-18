import 'package:coinmaster/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() async{
  runApp(const MyApp());
  
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color.fromRGBO(88, 60, 197, 1.0),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

