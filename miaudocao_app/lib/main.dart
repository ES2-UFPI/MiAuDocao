import 'package:flutter/material.dart';
import './utils/app_routes.dart';
import './views/cadastrar_animal_screen.dart';

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
        fontFamily: 'WorkSans'
      ),
      routes: {
        AppRoutes.HOME: (ctx) => MyHomePage(),
        AppRoutes.CADASTRAR_ANIMAL: (ctx) => CadastrarAnimalScreen()
      }
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
          children: [
            Icon(Icons.add),
            Text('Cadastrar animal')
          ],
        ),
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.CADASTRAR_ANIMAL),
      ),
    );
  }
}
