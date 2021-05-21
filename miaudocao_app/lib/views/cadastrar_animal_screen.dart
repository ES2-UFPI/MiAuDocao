import 'package:flutter/material.dart';
import '../widgets/animal_form.dart';

class CadastrarAnimalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastrar animal',
          style: TextStyle(
            fontWeight: FontWeight.w700
          ),
        ),
      ),
      body: Container(
        child: AnimalForm(),
      ),
    );
  }
}