import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:miaudocao_app/models/pergunta.dart';
import 'package:miaudocao_app/utils/configs.dart';

class PerguntaFacade {
  static final Dio _dio = Dio();

  static Future<List<Pergunta>> fetchPerguntas(String animalId) async {
    try {
      final response = await _dio
          .get('${Configs.API_URL}/animais/${animalId}/pergunta/all');
      
      final List<Pergunta> perguntas =
          (response.data as List).map((item) => Pergunta.fromJson(item)).toList();

      perguntas.sort((a, b) => b.dataCadastro.compareTo(a.dataCadastro));

      return perguntas;
    } catch (e) {
      print(e);
    }

    return null;
  }

  static void sendQuestion(String animalId, String autorId, String pergunta) async {
    try {
      await _dio.post('${Configs.API_URL}/animais/${animalId}/pergunta',
        data: json.encode({
          'autor_id': autorId,
          'pergunta': pergunta
        })
      );
    } on DioError catch (e) {
      print(e.response);
    }
  }

  static void sendAnswer(String animalId, String perguntaId, String resposta) async {
    try {
      await _dio.put('${Configs.API_URL}/animais/${animalId}/pergunta/${perguntaId}/responder',
        data: json.encode({
          'resposta': resposta
        })
      );
    } on DioError catch (e) {
      print(e.response);
    }
  }
}