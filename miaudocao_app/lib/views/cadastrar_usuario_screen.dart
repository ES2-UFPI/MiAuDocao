import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:miaudocao_app/models/usuario.dart';
import 'package:miaudocao_app/utils/configs.dart';
import 'package:miaudocao_app/widgets/user_form.dart';

class CadastrarUsuarioScreen extends StatelessWidget {
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

  _submitRegister(Usuario usuario, BuildContext context) async {
    context.loaderOverlay.show();
    try {
      final response = await this._dio.post(
        '${Configs.API_URL}/usuario', 
        data: json.encode({
          'nome': usuario.nome,
          'foto': usuario.foto,
          'email': usuario.email,
          'telefone': usuario.telefone,
          'password': usuario.password,
          'pref_especie': usuario.prefEspecie,
          'pref_porte': usuario.prefPorte,
          'pref_sexo': usuario.prefSexo,
          'pref_faixa_etaria': usuario.prefFaixaEtaria,
          'pref_raio_busca': usuario.prefRaioBusca
        })
      );

      context.loaderOverlay.hide();
      if (response.statusCode == 201) {
        _showSnackBar(context, 'Usuário cadastrado com sucesso! Agora você pode fazer o login.');
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
            'Cadastro',
            style: TextStyle(
              fontWeight: FontWeight.w700
            ),
          ),
        ),
        body: Container(
          child: UserForm(_submitRegister),
        ),
      ),
    );
  }
}