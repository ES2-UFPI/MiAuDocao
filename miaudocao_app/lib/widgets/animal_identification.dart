import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expandable_text/expandable_text.dart';

class AnimalIdentification extends StatelessWidget {

  final String nome;
  final String descricao;
  final String dataCadastro;

  AnimalIdentification({
    @required this.nome,
    @required this.descricao,
    @required this.dataCadastro
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            nome,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          child: ExpandableText(
            descricao,
            expandText: 'mais',
            maxLines: 3,
            animation: true,
            style: TextStyle(
              fontSize: 18
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              'No MiAuDoção desde: ',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              DateFormat('dd/MM/yyyy').format(
                  DateTime.fromMillisecondsSinceEpoch(int.parse(dataCadastro)))
            )
          ],
        ),
      ],
    );
  }
}