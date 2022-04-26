import 'package:flutter/material.dart';
import 'package:pixel_lego_art/logger.dart';
import 'package:pixel_lego_art/my_painter.dart';


void main() {
  MyLogger.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyPainter(),
    );
  }
}