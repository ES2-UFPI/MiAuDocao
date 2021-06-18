import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:miaudocao_app/utils/configs.dart';
import '../models/animal.dart';
import '../widgets/animal_form.dart';



class CadastrarAnimalScreen extends StatelessWidget {
  final Dio _dio = Dio();

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

  _submitRegister(Animal animal, BuildContext context) async {
    context.loaderOverlay.show();
    try {
      final response = await this._dio.post(
        '${Configs.API_URL}/animais', 
        data: json.encode({
          'nome': animal.nome,
          'descricao': animal.descricao,
          'especie': animal.especie,
          'porte': animal.porte,
          'sexo': animal.sexo,
          'faixa_etaria': animal.faixaEtaria,
          'endereco': animal.endereco,
          'latitude': animal.coordinates.latitude,
          'longitude': animal.coordinates.longitude,
          'foto': animal.foto,
        })
      );

      context.loaderOverlay.hide();
      if (response.statusCode == 201) {
        _showSnackBar(context, 'Animal cadastrado com sucesso!');
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
      context.loaderOverlay.hide();
      Navigator.of(context).pop();
      _showAlertDialog(
        context,
        'Algo deu errado',
        'Estamos com dificuldades de processar sua solicitação no momento. '
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