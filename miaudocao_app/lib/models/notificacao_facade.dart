import 'package:dio/dio.dart';
import 'package:miaudocao_app/models/notificacao.dart';
import 'package:miaudocao_app/utils/configs.dart';

class NotificacaoFacade {
  static final Dio _dio = Dio();

  static Future<List<Notificacao>> fetchNotificacoes(String userId) async {
    try {
      final response =
          await _dio.get('${Configs.API_URL}/usuario/${userId}/notificacoes');
      final List<Notificacao> notificacoes =
          (response.data as List).map((item) => Notificacao.fromJson(item)).toList();
      notificacoes.sort((a, b) => b.dataCadastro.compareTo(a.dataCadastro));

      return notificacoes;
    } catch (e) {
      print(e);
    }

    return null;
  }
}