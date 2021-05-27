import 'package:flutter/material.dart';

class AnimalInfoCard extends StatelessWidget {
  final String especie;
  final String porte;
  final String sexo;
  final String faixaEtaria;

  AnimalInfoCard({
    @required this.especie,
    @required this.porte,
    @required this.sexo,
    @required this.faixaEtaria
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
        boxShadow: kElevationToShadow[4],     
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              'Informações do animal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Row(
              children: [
                Text(
                  'Espécie: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(especie)
              ],
            ),
            Divider(),
            Row(
              children: [
                Text(
                  'Porte: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(porte)
              ],
            ),
            Divider(),
            Row(
              children: [
                Text(
                  'Sexo: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(sexo)
              ],
            ),
            Divider(),
            Row(
              children: [
                Text(
                  'Faixa etária: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(faixaEtaria)
              ],
            ),
          ],
        ),
      ),
    );

    return Container(
      width: double.infinity,
      child: Card(
        elevation: 2,
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              Text(
                'Informações do animal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Row(
                children: [
                  Text(
                    'Espécie: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(especie)
                ],
              ),
              Divider(),
              Row(
                children: [
                  Text(
                    'Porte: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(porte)
                ],
              ),
              Divider(),
              Row(
                children: [
                  Text(
                    'Sexo: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(sexo)
                ],
              ),
              Divider(),
              Row(
                children: [
                  Text(
                    'Faixa etária: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(faixaEtaria)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}