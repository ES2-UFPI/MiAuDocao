import 'package:flutter/cupertino.dart';

class Pergunta {
  final String id;
  final String idAutor;
  final String idAnimal;
  final String pergunta;
  final String resposta;
  final String dataCadastro;

  Pergunta({
    @required this.id,
    @required this.idAutor,
    @required this.idAnimal,
    @required this.pergunta,
    @required this.resposta,
    @required this.dataCadastro
  });

  static Pergunta fromJson(Map<String, dynamic> json) {
    return Pergunta(
      id: json['id'],
      idAutor: json['id_autor'],
      idAnimal: json['id_animal'],
      pergunta: json['pergunta'],
      resposta: json['resposta'],
      dataCadastro: json['data_cadastro']
    );
  }
}