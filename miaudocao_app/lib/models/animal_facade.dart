import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:miaudocao_app/models/animal.dart';
import 'package:miaudocao_app/utils/configs.dart';

class AnimalFacade {
  static final Dio _dio = Dio();

  static Future<Animal> fetchAnimal(String animalId, String userId) async {
    try {
      final response = await _dio
          .get('${Configs.API_URL}/animais',
            queryParameters: {
              'id': animalId,
              'user': userId
            }
          );
      return Animal.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<bool> fetchIsAnimalFavorite(String animalId, String userId) async {
    try {
      final response = await _dio
          .get('${Configs.API_URL}/animais',
            queryParameters: {
              'id': animalId,
              'user': userId
            }
          );
      return response.data['favorito'];
    } catch (e) {
      print(e);
    }
    return null;
  }

  static void saveFavorito(String animalId, String userId) async {
    try {
      await _dio.post('${Configs.API_URL}/favorito',
        data: {
          'user_id': userId,
          'animal_id': animalId
        }
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> manifestarInteresse(String animalId, String userId) async {
    try {
      await _dio.post(
        '${Configs.API_URL}/manifestar_interesse',
        queryParameters: {
          'animal': animalId,
          'user': userId
        }
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<Animal>> searchAnimals({
      String especie, String porte, String sexo, String faixaEtaria,
      String latitude, String longitude, double raio}) async {
    try {
      final response = await _dio.get('${Configs.API_URL}/busca',
        queryParameters: {
          'especie': especie,
          'porte': porte,
          'sexo': sexo,
          'faixa': faixaEtaria,
          'lat': latitude,
          'lng':longitude,
          'raio': raio
        }
      );
      final List<Animal> animais =
          (response.data as List).map((item) => Animal.fromJson(item)).toList();

      return animais;
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<bool> registerAnimal({
      String userId, String nome, String descricao, String especie,
      String porte, String sexo, String, faixaEtaria, String endereco,
      String latitude, String longitude, String foto}) async {
    try {
      final response = await _dio.post('${Configs.API_URL}/animais', 
        data: json.encode({
          'user_id': userId,
          'nome': nome,
          'descricao': descricao,
          'especie': especie,
          'porte': porte,
          'sexo': sexo,
          'faixa_etaria': faixaEtaria,
          'endereco': endereco,
          'latitude': latitude,
          'longitude': longitude,
          'foto': foto,
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

  static Future<List<Animal>> fetchUserAnimals(String userId) async {
    try {
      final response = await _dio.get('${Configs.API_URL}/usuario/animais',
          queryParameters: {'user': userId});
      final List<Animal> animais =
          (response.data as List).map((item) => Animal.fromJson(item)).toList();
      animais.sort((a, b) => b.data.compareTo(a.data));

      return animais;
    } catch (e) {
      print(e);
    }

    return null;
  }

  static void markAnimalAsAdopted(String animalId) async {
    try {
      _dio.put('${Configs.API_URL}/animais/marcar_adotado',
        queryParameters: {
          'id': animalId
        }
      );
    } catch (e) {
      print(e);
    }
  }
}