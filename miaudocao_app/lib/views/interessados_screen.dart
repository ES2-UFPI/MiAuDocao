import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:miaudocao_app/utils/configs.dart';
import 'package:miaudocao_app/views/perfil_usuario_screen.dart';

class InteressadosScreen extends StatefulWidget {
  final String animalId;
  InteressadosScreen(this.animalId);

  @override
  _InteressadosScreenState createState() => _InteressadosScreenState();
}

class _InteressadosScreenState extends State<InteressadosScreen> {
  Dio _dio = Dio();
  bool _isLoading = true;
  Future _interessados;
  // Criar uma classe UserSimplified para representar um usuário com algumas infos.
  Future _getInteressados() async {
    try {
      final response = await this._dio.get('${Configs.API_URL}/animais/interessados',
          queryParameters: {'id': widget.animalId});

      setState(() {
        _isLoading = false;
      });

      return response.data;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    _interessados = _getInteressados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interessados'),
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData == false || _isLoading == true) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data.length == 0) {
              print(snapshot.data);
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Parece que ainda não há nenhuma pessoa interessada neste animal.',
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 45),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amberAccent,
                      backgroundImage: MemoryImage(
                        base64Decode(snapshot.data[index]['foto'].split(',')[1])
                      )
                    ),
                    title: Text(snapshot.data[index]['nome']),
                    onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (context) => PerfilUsuarioScreen(snapshot.data[index]['id']),
                      )),
                  ),
                );
              },
            );
          },
          future: _interessados,
        ),
    );
  }
}