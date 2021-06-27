import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miaudocao_app/utils/app_routes.dart';

class AnimalItem extends StatelessWidget {
  final String image;
  final String nome;
  final String descricao;
  final String id;
  final String userId;
  final bool adotado;
  final bool showOptions;
  final Function showInteressados;
  final Function marcarAdotado;

  AnimalItem({
    @required this.image,
    @required this.nome,
    @required this.descricao,
    @required this.id,
    @required this.userId,
    @required this.adotado,
    this.showOptions = false,
    this.showInteressados,
    this.marcarAdotado
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Stack(
          children: [
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8
              ),
              child: Column(
                children: [
                   ClipRRect(
                     borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(6),
                       topRight: Radius.circular(6)
                     ),
                     child: Image.memory(
                      base64Decode(image.split(',')[1]),
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                  ),
                   ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: 5
                    ),
                    child: Text(
                      nome,
                      style: TextStyle(
                        fontSize: 20
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 10,
                      right: 10,
                      bottom: 2
                    ),
                    child: Text(
                      descricao,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  showOptions && !adotado
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: showInteressados,
                            child: Text('Ver interessados')
                          ),
                          TextButton(
                            onPressed: marcarAdotado,
                            child: Text('Marcar como adotado')
                          )
                        ],
                      )
                    : SizedBox(height: 10)
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 26,
              child: adotado
                ? Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  
                  child: Text(
                    'ADOTADO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  )
                )
                : Container(),
            )
          ],
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed(          
            AppRoutes.VISUALIZAR_ANIMAL,
            arguments: [id, userId]
          ),
    );
  }
}