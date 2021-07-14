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
}