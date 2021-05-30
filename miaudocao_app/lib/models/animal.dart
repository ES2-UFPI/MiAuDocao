import 'package:flutter/cupertino.dart';
import 'package:miaudocao_app/utils/places_service.dart';

import '../utils/places_service.dart';

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
  final String id;
  final String dataCadastro;
  final double distancia;
  final int data;

  Animal(
      {@required this.nome,
      @required this.descricao,
      @required this.foto,
      @required this.especie,
      @required this.porte,
      @required this.sexo,
      @required this.faixaEtaria,
      @required this.endereco,
      @required this.coordinates,
      this.id,
      this.dataCadastro,
      this.distancia,
      this.data});

  static Animal fromJson(Map<String, dynamic> json) {
    return Animal(
        nome: json['nome'],
        descricao: json['descricao'],
        foto: json['foto'],
        especie: json['especie'],
        porte: json['porte'],
        sexo: json['sexo'],
        faixaEtaria: json['faixa_etaria'],
        endereco: json['endereco'],
        coordinates: Coordinates(
            latitude: json['latitude'], longitude: json['longitude']),
        id: json['id'],
        dataCadastro: json['data_cadastro'],
        distancia: json['distance'],
        data: int.parse(json['data_cadastro']));
  }
}
