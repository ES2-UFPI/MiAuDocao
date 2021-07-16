import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:miaudocao_app/models/animal_facade.dart';
import '../models/animal.dart';
import '../widgets/animal_form.dart';

// ignore: must_be_immutable
class CadastrarAnimalScreen extends StatelessWidget {
  final String userId;
  CadastrarAnimalScreen(this.userId);

  _showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message)
      )
    );
  }

  _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              }
            )
          ],
        );
      }
    );
  }

  void _submitRegister(Animal animal, BuildContext context) async {
    context.loaderOverlay.show();
    bool registered = await AnimalFacade.registerAnimal(
      userId: userId,
      nome: animal.nome,
      descricao: animal.descricao,
      especie: animal.especie,
      porte: animal.porte,
      sexo: animal.sexo,
      faixaEtaria: animal.faixaEtaria,
      endereco: animal.endereco,
      latitude: animal.coordinates.latitude.toString(),
      longitude: animal.coordinates.longitude.toString(),
      foto: animal.foto,
    );
    context.loaderOverlay.hide();

    if (registered == true) {
      _showSnackBar(context, 'Animal cadastrado com sucesso!');
        Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
      _showAlertDialog(
        context,
        'Algo deu errado',
        'Não conseguimos cadastrar o animal no momento. '
            + 'Você pode verificar os dados enviados ou tentar novamente mais '
            + 'tarde.'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Cadastrar animal',
            style: TextStyle(
              fontWeight: FontWeight.w700
            ),
          ),
        ),
        body: Container(
          child: AnimalForm(_submitRegister),
        ),
      ),
    );
  }
}