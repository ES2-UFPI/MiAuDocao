import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:miaudocao_app/models/usuario.dart';
import 'package:miaudocao_app/utils/app_routes.dart';
import 'package:miaudocao_app/utils/configs.dart';
import 'package:miaudocao_app/widgets/custom_textfield.dart';

class WelcomeLoginScreen extends StatelessWidget {
  final Dio _dio = Dio();

  _showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: Text(message)));
  }

  void _login(String email, BuildContext context) async {
    context.loaderOverlay.show();
    try {
      final response =
          await this._dio.get('${Configs.API_URL}/usuario?email=${email}');
      context.loaderOverlay.hide();
      if (response.statusCode == 200) {
        Navigator.of(context).pushNamed(AppRoutes.DASHBOARD,
            arguments: Usuario.fromJson(response.data));
      }
    } catch (e) {
      context.loaderOverlay.hide();
      _showSnackBar(context, 'Usuário não encontrado.');
      print(e);
    }
    return null;
  }

  final _emailInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.amber, Colors.orange])),
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.pets),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'MiAuDoção',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        'Bem-vindo(a)',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        'Faça login para continuar',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomTextField(
                      hint: 'E-mail',
                      maxLength: 100,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailInputController,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.grey.shade200),
                      onPressed: () =>
                          _login(_emailInputController.text, context),
                      child: Text('Entrar'),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text('Não possui conta? '),
                    GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.CADASTRAR_USUARIO),
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
