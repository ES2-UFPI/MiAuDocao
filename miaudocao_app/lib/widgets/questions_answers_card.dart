import 'package:flutter/material.dart';
import 'package:miaudocao_app/models/pergunta.dart';

class QuestionAnswersCard extends StatelessWidget {
  final List<dynamic> _perguntas;
  final Function() onTap;
  QuestionAnswersCard(this._perguntas, this.onTap);

  Pergunta _getMostRecentQuestion() {
    _perguntas.sort((a, b) => b.dataCadastro.compareTo(a.dataCadastro));

    if (_perguntas.length == 0) {
      return Pergunta(
        id: '0',
        idAutor: '0',
        idAnimal: '0',
        pergunta: 'Perguntas aparecerão aqui',
        resposta: 'Respostas aparecerão aqui',
        dataCadastro: '0');
    }

    return _perguntas[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
        boxShadow: kElevationToShadow[4],     
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              'Perguntas e respostas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            Divider(
              thickness: 2,
            ),
            _getMostRecentQuestion().id == '0'
              ? Text('Nenhuma pergunta')
              : Column(
                  children: [
                    Text(
                      'Última pergunta',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      child: Text(
                        _getMostRecentQuestion().pergunta,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    _getMostRecentQuestion().resposta == ''
                      ? Container(
                          width: double.infinity,
                          child: Text('Ainda sem resposta.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          child: Text(
                            _getMostRecentQuestion().resposta,
                            textAlign: TextAlign.start,
                          ),
                        ),
              ],
            ),
            SizedBox(height: 5),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Text(
                  'Ver ou fazer perguntas',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}