import 'package:flutter/material.dart';
import 'package:miaudocao_app/views/tabs_screen.dart';
import './utils/app_routes.dart';
import './views/cadastrar_animal_screen.dart';
import 'package:miaudocao_app/widgets/custom_textfield.dart';
import 'utils/app_routes.dart';
import 'views/visualizar_animal_screen.dart';

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

class MyHomePage extends StatelessWidget {
  final _idAnimalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MiAuDoção',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          CustomTextField(
            hint: "Digite um ID válido",
            maxLength: 20,
            controller: _idAnimalController,
            showCounter: true,
          ),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(
                  AppRoutes.VISUALIZAR_ANIMAL,
                  arguments: _idAnimalController.text.toString()),
              child: Text('Visualizar animal'))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
          children: [Icon(Icons.add), Text('Cadastrar animal')],
        ),
        onPressed: () =>
            Navigator.of(context).pushNamed(AppRoutes.CADASTRAR_ANIMAL),
      ),
    );
  }
}
