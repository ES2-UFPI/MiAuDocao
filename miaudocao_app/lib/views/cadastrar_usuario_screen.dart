import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:miaudocao_app/models/usuario.dart';
import 'package:miaudocao_app/models/usuario_facade.dart';
import 'package:miaudocao_app/widgets/user_form.dart';

class CadastrarUsuarioScreen extends StatelessWidget {
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

  void _submitRegister(Usuario usuario, BuildContext context) async {
    context.loaderOverlay.show();
    bool registered = await UsuarioFacade.registerUser(
      nome: usuario.nome,
      foto: usuario.foto,
      email: usuario.email,
      telefone: usuario.telefone,
      password: usuario.password,
      prefEspecie: usuario.prefEspecie,
      prefPorte: usuario.prefPorte,
      prefSexo: usuario.prefSexo,
      prefFaixaEtaria: usuario.prefFaixaEtaria,
      prefRaioBusca: usuario.prefRaioBusca
    );

    context.loaderOverlay.hide();
    if (registered == true) {
      _showSnackBar(context, 'Usuário cadastrado com sucesso! Agora você pode fazer o login.');
      Navigator.of(context).pop();
    } else {
      context.loaderOverlay.hide();
      Navigator.of(context).pop();
      _showAlertDialog(
        context,
        'Algo deu errado',
        'Não conseguimos realizar o seu cadastro no momento. '
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