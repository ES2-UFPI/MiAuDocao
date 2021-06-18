import 'package:flutter/foundation.dart';

class Usuario {
  final String id;
  final String nome;
  final String foto;
  final String email;
  final String telefone;
  final String password;
  final String prefEspecie;
  final String prefPorte;
  final String prefSexo;
  final String prefFaixaEtaria;
  final int prefRaioBusca;
  final String dataCadastro;

  Usuario({
    @required this.nome,
    @required this.foto,
    @required this.email,
    @required this.telefone,
    @required this.prefEspecie,
    @required this.prefPorte,
    @required this.prefSexo,
    @required this.prefFaixaEtaria,
    @required this.prefRaioBusca,
    this.password,
    this.id,
    this.dataCadastro
  });

  static Usuario fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      foto: json['foto'],
      email: json['email'],
      telefone: json['telefone'],
      dataCadastro: json['data_cadastro'],
      prefEspecie: json['pref_especie'],
      prefPorte: json['pref_porte'],
      prefSexo: json['pref_sexo'],
      prefFaixaEtaria: json['pref_faixa_etaria'],
      prefRaioBusca: json['pref_raio_busca']
    );
  }
}