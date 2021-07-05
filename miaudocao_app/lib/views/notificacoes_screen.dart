import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miaudocao_app/models/notificacao.dart';
import 'package:miaudocao_app/utils/configs.dart';

class NotificacoesScreen extends StatefulWidget {
  final String userId;
  NotificacoesScreen(this.userId);

  @override
  _NotificacoesScreenState createState() => _NotificacoesScreenState();
}

class _NotificacoesScreenState extends State<NotificacoesScreen> {
  final Dio _dio = new Dio();
  Future<List<Notificacao>> _notificacoes;
  bool _isLoading = true;

  Future<List<Notificacao>> _fetchNotifications() async {
    setState(() => _isLoading = true);
    try {
      final response =
          await this._dio.get('${Configs.API_URL}/usuario/${widget.userId}/notificacoes');

      final List<Notificacao> notificacoes =
          (response.data as List).map((item) => Notificacao.fromJson(item)).toList();

      setState(() {
        _isLoading = false;
      });

      return notificacoes;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _notificacoes = _fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notificações',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData == false || _isLoading == true) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.length == 0) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Sem notificações',
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(snapshot.data[index].titulo),
                  subtitle: Text(snapshot.data[index].descricao),
                  trailing: Text(DateFormat('dd/MM/yyyy\nHH:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data[index].dataCadastro))),
                    textAlign: TextAlign.end),
                  onTap: () => {},
                ),
              );
            },
          );
        },
        future: _notificacoes,
      ),
    );
  }
}