import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.amberAccent,
        fontFamily: 'WorkSans',
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontSize: 20,
            fontFamily: 'WorkSans'
          )
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MiAuDoção',
          style: TextStyle(
            fontWeight: FontWeight.w700
          ),
        ),
      ),
      body: Text(
        'Este é o início do MiAuDoção',
        style: TextStyle(
          fontFamily: 'WorkSans',
          fontWeight: FontWeight.w500,
          fontSize: 16
        )
      )
    );
  }
}
