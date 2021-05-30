import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miaudocao_app/utils/app_routes.dart';

class AnimalItem extends StatelessWidget {
  final String image;
  final String nome;
  final String descricao;
  final String id;

  AnimalItem({
    @required this.image,
    @required this.nome,
    @required this.descricao,
    @required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Card(
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
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 5,
                  left: 10,
                  right: 10,
                  bottom: 10
                ),
                child: Text(
                  descricao,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed(          
            AppRoutes.VISUALIZAR_ANIMAL,
            arguments: id
          ),
    );
  }
}