import 'package:flutter/material.dart';
import 'package:miaudocao_app/models/usuario.dart';
import 'package:miaudocao_app/views/cadastrar_usuario_screen.dart';
import 'package:miaudocao_app/views/interessados_screen.dart';
import 'package:miaudocao_app/views/tabs_screen.dart';
import 'package:miaudocao_app/views/welcome_login_screen.dart';
import './utils/app_routes.dart';
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
        //AppRoutes.HOME: (ctx) => TabsScreen(),
        AppRoutes.HOME: (ctx) => WelcomeLoginScreen(),
        AppRoutes.CADASTRAR_USUARIO: (ctx) => CadastrarUsuarioScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.VISUALIZAR_ANIMAL) {
          final String argument = settings.arguments;

          return MaterialPageRoute(builder: (context) {
            return VisualizarAnimalScreen(argument);
          });
        }

        if (settings.name == AppRoutes.DASHBOARD) {
          final Usuario argument = settings.arguments;

          return MaterialPageRoute(builder: (context) {
            return TabsScreen(argument);
          });
        }

        if (settings.name == AppRoutes.INTERESSADOS) {
          final String argument = settings.arguments;

          return MaterialPageRoute(builder: (context) {
            return InteressadosScreen(argument);
          });
        }

        return null;
      },
    );
  }
}
