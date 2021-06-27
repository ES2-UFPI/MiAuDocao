import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miaudocao_app/models/usuario.dart';
import 'package:miaudocao_app/utils/configs.dart';

class PerfilUsuarioScreen extends StatefulWidget {
  final String userId;
  PerfilUsuarioScreen(this.userId);

  @override
  _PerfilUsuarioScreenState createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen> {
  Dio _dio = Dio();
  bool _isLoading = false;
  Future<Usuario> _usuario;

  Future<Usuario> _fetchUsuario() async {
    try {
      final response = await _dio.get(
        '${Configs.API_URL}/usuario',
        queryParameters: {
          'email': widget.userId
        }
      );
      setState(() {
        _isLoading = false;
      });
      return Usuario.fromJson(response.data);
    } catch (e) {
      print (e);
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _usuario = _fetchUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: MemoryImage(base64Decode(
                                      snapshot.data.foto.split(',')[1])))),
                        ),
                        SizedBox(width: 16),
                        Flexible(
                          child: Container(
                            //width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data.nome,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: TextStyle(
                                      fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text('No MiAuDoção desde: ' +
                                    DateFormat('dd/MM/yyyy').format(
                                        DateTime.fromMillisecondsSinceEpoch(int.parse(
                                            snapshot.data.dataCadastro)))),
                                SizedBox(height: 5),
                                Text('E-mail: ${snapshot.data.email}'),
                                SizedBox(height: 5),
                                Text('Telefone: ${snapshot.data.telefone}'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Icon(
                            Icons.pets
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Este(a) usuário(a) está interessado(a) no animal. Combine a adoção entrando em contato com ele(a).',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          TextButton(
                            onPressed: () => {},
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.warning),
                                SizedBox(width: 10),
                                Text('Denunciar irregularidade')
                              ],
                            ),
                          ),
                        ],
                      )
                    )
                  ],
                ),
              );
            }
            return Text('Algo deu errado');
          },
          future: _usuario,
        )
    );
  }
}