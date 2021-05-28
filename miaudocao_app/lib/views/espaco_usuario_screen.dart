import 'package:flutter/material.dart';
import 'package:miaudocao_app/utils/app_routes.dart';

class EspacoUsuarioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu espaço'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
          children: [
            Icon(Icons.add),
            SizedBox(width: 5,),
            Text(
              'Cadastrar animal',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.CADASTRAR_ANIMAL),
      ),
    );
  }
}