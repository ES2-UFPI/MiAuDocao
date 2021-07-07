import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:miaudocao_app/models/pergunta.dart';
import 'package:miaudocao_app/utils/configs.dart';
import 'package:miaudocao_app/widgets/custom_textfield.dart';

class PerguntasScreen extends StatefulWidget {
  final String animalId;
  PerguntasScreen(this.animalId);

  @override
  _PerguntasScreenState createState() => _PerguntasScreenState();
}

class _PerguntasScreenState extends State<PerguntasScreen> {
  final Dio _dio = Dio();
  Future<List<Pergunta>> _perguntas;
  bool _isLoading = false;

  Future<List<Pergunta>> _fetchPerguntas() async {
    setState(() => _isLoading = true);
    try {
      final response = await this
          ._dio
          .get('${Configs.API_URL}/animais/${widget.animalId}/pergunta/all');
      
      final List<Pergunta> perguntas =
          (response.data as List).map((item) => Pergunta.fromJson(item)).toList();
      setState(() => _isLoading = false);

      return perguntas;
    } catch (e) {
      print(e);
    }

    return null;
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
                      child: Padding(
                        padding: const EdgeInsets.all(10),
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
                      )
                    );
                  },
                );
              },
              future: _perguntas,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hint: 'Escreva sua pergunta',
                    maxLength: 200,
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
                    onPressed: () => {},
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