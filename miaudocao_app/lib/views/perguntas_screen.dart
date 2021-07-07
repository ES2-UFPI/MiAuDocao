import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:miaudocao_app/models/pergunta.dart';
import 'package:miaudocao_app/utils/configs.dart';
import 'package:miaudocao_app/widgets/custom_textfield.dart';

class PerguntasScreen extends StatefulWidget {
  final List<String> arguments;
  PerguntasScreen(this.arguments);

  @override
  _PerguntasScreenState createState() => _PerguntasScreenState();
}

class _PerguntasScreenState extends State<PerguntasScreen> {
  final Dio _dio = Dio();
  Future<List<Pergunta>> _perguntas;
  bool _isLoading = false;
  bool _isSending = false;
  TextEditingController _perguntaController = new TextEditingController();
  TextEditingController _respostaController = new TextEditingController();

  Future<List<Pergunta>> _fetchPerguntas() async {
    setState(() => _isLoading = true);
    try {
      final response = await this
          ._dio
          .get('${Configs.API_URL}/animais/${widget.arguments[0]}/pergunta/all');
      
      final List<Pergunta> perguntas =
          (response.data as List).map((item) => Pergunta.fromJson(item)).toList();
      setState(() => _isLoading = false);

      perguntas.sort((a, b) => b.dataCadastro.compareTo(a.dataCadastro));

      return perguntas;
    } catch (e) {
      print(e);
    }

    return null;
  }

  void _sendQuestion(BuildContext context) async {
    FocusScope.of(context).unfocus();
    setState(() => _isSending = true);
    try {
      await this._dio.post('${Configs.API_URL}/animais/${widget.arguments[0]}/pergunta',
        data: json.encode({
          'autor_id': widget.arguments[1],
          'pergunta': _perguntaController.text
        })
      );
      setState(() {
        _perguntas = _fetchPerguntas();
        _perguntaController.clear();
        _isSending = false;
      });
    } on DioError catch (e) {
      print(e.response);
    }
  }

  void _sendAnswer(BuildContext context, String animalId, String perguntaId) async {
    FocusScope.of(context).unfocus();
    setState(() => _isSending = true);
    try {
      await this._dio.put('${Configs.API_URL}/animais/${animalId}/pergunta/${perguntaId}/responder',
        data: json.encode({
          'resposta': _respostaController.text
        })
      );
      Navigator.of(context).pop();
      setState(() {
        _perguntas = _fetchPerguntas();
        _respostaController.clear();
        _isSending = false;
      });
    } on DioError catch (e) {
      print(e.response);
    }
  }

  void _openAnswerModal(BuildContext context, String pergunta, String animalId, String perguntaId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: _isSending
            ? Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 10),
                  Text('Enviando...'),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      pergunta,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hint: 'Digite sua resposta',
                          maxLength: 200,
                          controller: _respostaController,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          shape: BoxShape.circle
                        ),
                        child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () => _sendAnswer(context, animalId, perguntaId),
                        ),
                      )
                    ],
                  )
                ],
              )
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();

    _perguntas = _fetchPerguntas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perguntas'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
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
                            Icons.warning,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Sem perguntas',
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
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      snapshot.data[index].pergunta,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  snapshot.data[index].resposta == ''
                                    ? Container(
                                        width: double.infinity,
                                        child: Text(
                                          'Ainda sem resposta.',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey.shade600
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                    )
                                    : Container(
                                        width: double.infinity,
                                        child: Text(
                                          snapshot.data[index].resposta,
                                          textAlign: TextAlign.start,
                                        ),
                                    ),
                                ],
                              ),
                            ),
                            widget.arguments[2] == 'resposta' && snapshot.data[index].resposta == ''
                              ? TextButton(
                                  onPressed: () => _openAnswerModal(context, snapshot.data[index].pergunta, snapshot.data[index].idAnimal, snapshot.data[index].id),
                                  child: Text('Responder')
                                )
                              : Container(),
                          ],
                        ),
                      )
                    );
                  },
                );
              },
              future: _perguntas,
            ),
          ),
          widget.arguments[2] == 'resposta'
            ? Container()
            : _isSending
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 10),
                      Text('Enviando...'),
                    ],
                  )
                )
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hint: 'Escreva sua pergunta',
                          maxLength: 200,
                          controller: _perguntaController,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          shape: BoxShape.circle
                        ),
                        child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () => _sendQuestion(context),
                        ),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}