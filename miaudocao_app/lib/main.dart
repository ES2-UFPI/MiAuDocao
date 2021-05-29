import 'package:flutter/material.dart';
import 'package:miaudocao_app/views/tabs_screen.dart';
import './utils/app_routes.dart';
import './views/cadastrar_animal_screen.dart';
import 'utils/app_routes.dart';
import 'views/visualizar_animal_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiAuDoção',
      theme: ThemeData(
          primarySwatch: Colors.amber,
          accentColor: Colors.amberAccent,
          fontFamily: 'WorkSans'),
      routes: {
        AppRoutes.HOME: (ctx) => TabsScreen(),
        AppRoutes.CADASTRAR_ANIMAL: (ctx) => CadastrarAnimalScreen()
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.VISUALIZAR_ANIMAL) {
          final String argument = settings.arguments;

          return MaterialPageRoute(builder: (context) {
            return VisualizarAnimalScreen(argument);
          });
        }

        return null;
      },
    );
  }
}