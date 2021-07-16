import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:miaudocao_app/models/usuario.dart';
import 'package:miaudocao_app/utils/configs.dart';

class UsuarioFacade {
  static final Dio _dio = Dio();

  static Future<Usuario> fetchUserByEmail(String email) async {
    try {
      final response =
          await _dio.get('${Configs.API_URL}/usuario?email=${email}');
      if (response.statusCode == 200) {
        return Usuario.fromJson(response.data);
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<Usuario> fetchUserById(String userId) async {
    try {
      final response = await _dio.get(
        '${Configs.API_URL}/usuario',
        queryParameters: {
          'email': userId
        }
      );

      return Usuario.fromJson(response.data);
    } catch (e) {
      print (e);
    }

    return null;
  }

  static Future<bool> registerUser({
      String nome, String foto, String email, String telefone, String password,
      String prefEspecie, String prefPorte, String prefSexo, String prefFaixaEtaria,
      int prefRaioBusca}) async {

    try {
      final response = await _dio.post(
        '${Configs.API_URL}/usuario', 
        data: json.encode({
          'nome': nome,
          'foto': foto,
          'email': email,
          'telefone': telefone,
          'password': password,
          'pref_especie': prefEspecie,
          'pref_porte': prefPorte,
          'pref_sexo': prefSexo,
          'pref_faixa_etaria': prefFaixaEtaria,
          'pref_raio_busca': prefRaioBusca
        })
      );
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
  
}