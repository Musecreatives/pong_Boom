import 'package:flutter/material.dart';
import './pong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pong Boom',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home:  Scaffold(
        appBar: AppBar(
          title: const Text('Simple png game'),
          ),
          body: SafeArea(child: Pong()),
          ),
    );
  }
}

