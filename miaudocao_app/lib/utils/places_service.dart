import 'package:dio/dio.dart';

class Place {
  final String placeId, description;
  
  Place({ this.placeId, this.description });

  static Place fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['place_id'],
      description: json['description'],
    );
  }
}

class AutocompleteApi {
  AutocompleteApi._internal();
  static AutocompleteApi get instance => AutocompleteApi._internal();
  final Dio _dio = Dio();

  final apiKey = 'API_KEY';

  Future<List<Place>> searchPredictions(String input) async {
    try {
      final response = await this._dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': input,
          'key': apiKey,
          'types': 'address',
          'location': '-5.093040,-42.781603',
          'radius': '1000',
          'language': 'pt-BR',
          'components': 'country:br',
        }
      );
      final List<Place> places = (response.data['predictions'] as List)
          .map((item) => Place.fromJson(item)).toList();
      return places;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class Coordinates {
  final double latitude, longitude;
  
  Coordinates({ this.latitude, this.longitude });
}

class DetailsApi {
  DetailsApi._internal();
  static DetailsApi get instance => DetailsApi._internal();
  final Dio _dio = Dio();

  final apiKey = 'AIzaSyCQCqMN_YGLTyQMry-IrtQ_0uNAJ-gCErc';
  Future<Coordinates> getCoordinates(String placeId) async {
    try {
      final response = await this._dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'key': apiKey,
          'place_id': placeId
        }
      );
      final data = response.data['result']['geometry']['location'];
      return Coordinates(latitude: data['lat'], longitude: data['lng']);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
