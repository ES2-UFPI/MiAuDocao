import 'package:flutter/foundation.dart';

class Notificacao {
  final String id;
  final String userId;
  final String titulo;
  final String descricao;
  final String dataCadastro;
  final String tipo;
  final String idTipo;

  Notificacao({
    @required this.id,
    @required this.userId,
    @required this.titulo,
    @required this.descricao,
    @required this.dataCadastro,
    @required this.tipo,
    @required this.idTipo
  });

  static Notificacao fromJson(Map<String, dynamic> json) {
    return Notificacao(
      id: json['id'],
      userId: json['user_id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      dataCadastro: json['data_cadastro'],
      tipo: json['tipo'],
      idTipo: json['id_tipo']
    );
  }
}