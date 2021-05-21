import 'package:flutter/cupertino.dart';
import 'package:miaudocao_app/utils/places_service.dart';

class Animal {

  final String nome;
  final String descricao;
  final String foto;
  final String especie;
  final String porte;
  final String sexo;
  final String faixaEtaria;
  final String endereco;
  final Coordinates coordinates;

  Animal({
    @required this.nome,
    @required this.descricao,
    @required this.foto,
    @required this.especie,
    @required this.porte,
    @required this.sexo,
    @required this.faixaEtaria,
    @required this.endereco,
    @required this.coordinates
  });

}