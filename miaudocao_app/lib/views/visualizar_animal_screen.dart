import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:measurer/measurer.dart';
import 'package:miaudocao_app/models/animal.dart';
import 'package:miaudocao_app/models/pergunta.dart';
import 'package:miaudocao_app/utils/app_routes.dart';
import 'package:miaudocao_app/utils/configs.dart';
import 'package:miaudocao_app/utils/places_service.dart';
import 'package:miaudocao_app/widgets/address_details_modal.dart';
import 'package:miaudocao_app/widgets/address_info_card.dart';
import 'package:miaudocao_app/widgets/animal_identification.dart';
import 'package:miaudocao_app/widgets/animal_info_card.dart';
import 'package:miaudocao_app/widgets/fullscreen_image.dart';
import 'package:miaudocao_app/widgets/questions_answers_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/animal.dart';

class VisualizarAnimalScreen extends StatefulWidget {
  final List<String> _animalAndUserId;
  VisualizarAnimalScreen(this._animalAndUserId);

  @override
  _VisualizarAnimalScreenState createState() => _VisualizarAnimalScreenState();
}

class _VisualizarAnimalScreenState extends State<VisualizarAnimalScreen> {
  Size _bodySize = Size(0, 0);
  Size _floatingActionButtonSize = Size(0, 0);
  bool _interesseManifestado = false;

  final Dio _dio = Dio();
  Future<Animal> _animal;
  Future<List<Pergunta>> _perguntas;
  
  Future<Animal> fetchAnimal() async {
    try {
      final response = await this
          ._dio
          .get('${Configs.API_URL}/animais',
            queryParameters: {
              'id': widget._animalAndUserId[0],
              'user': widget._animalAndUserId[1]
            }
          );
      return Animal.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Pergunta>> _fetchPerguntas() async {
    try {
      final response = await this
          ._dio
          .get('${Configs.API_URL}/animais/${widget._animalAndUserId[0]}/pergunta/all');
      
      final List<Pergunta> perguntas =
          (response.data as List).map((item) => Pergunta.fromJson(item)).toList();

      return perguntas;
    } catch (e) {
      print(e);
    }

    return null;
  }

  _showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message)
      )
    );
  }

  void _manifestarInteresse(BuildContext context) async {
    context.loaderOverlay.show();
    try {
      await this._dio.post(
        '${Configs.API_URL}/manifestar_interesse',
        queryParameters: {
          'animal': widget._animalAndUserId[0],
          'user': widget._animalAndUserId[1]
        }
      );
      context.loaderOverlay.hide();
      _showSnackBar(context, 'Interesse registrado com sucesso');
      setState(() {
        _interesseManifestado = true;
      });
    } catch (e) {
      print(e);
      _showSnackBar(context, 'Algo deu errado.');
    }
  }

  @override
  void initState() {
    super.initState();

    _animal = fetchAnimal();
    _perguntas = _fetchPerguntas();
  }

  _openAddressDetailsModal(
      BuildContext context, String endereco, Coordinates coordinates) {
    showBarModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20)),
        ),
        builder: (context) {
          return AddressDetailsModal(
              endereco: endereco, coordinates: coordinates);
        });
  }

  _openQuestionsScreen(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.PERGUNTAS, arguments: widget._animalAndUserId[0]);
  }

  _getFloatingActionButton(String animalUser, bool interesseManifestado, bool interessado) {
    if (widget._animalAndUserId[1] == animalUser) {
      return FloatingActionButton.extended(
        onPressed: null,
        label: Row(
          children: [
            Icon(Icons.edit),
            SizedBox(width: 10),
            Text('Editar animal',
                style: TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      );
    } else if (interesseManifestado || interessado) {
      return FloatingActionButton.extended(
        backgroundColor: Colors.amber.shade100,
        onPressed: null,
        label: Row(
          children: [
            Icon(Icons.check),
            SizedBox(width: 10),
            Text('Interessado',
                style: TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: () => _manifestarInteresse(context),
        label: Row(
          children: [
            Icon(Icons.pets),
            SizedBox(width: 10),
            Text('Tenho interesse',
                style: TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Informações do animal'),
            actions: [
              IconButton(icon: Icon(Icons.favorite_outline), onPressed: () => {})
            ],
          ),
          body: Measurer(
            onMeasure: (size, constraints) {
              setState(() {
                _bodySize = size;
              });
            },
            child: FutureBuilder<Animal>(
              future: _animal,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    boxShadow: kElevationToShadow[4]),
                                child: GestureDetector(
                                  child: Image.memory(
                                    base64Decode(
                                        snapshot.data.foto.split(',')[1]),
                                    fit: BoxFit.cover,
                                  ),
                                  onTap: () => Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return FullscreenImage(snapshot.data.foto);
                                    })),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 6,
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 10 +
                                            (_floatingActionButtonSize.height /
                                                2),
                                        left: 16,
                                        right: 16,
                                        bottom: 16),
                                    child: Column(
                                      children: [
                                        AnimalIdentification(
                                            nome: snapshot.data.nome,
                                            descricao: snapshot.data.descricao,
                                            dataCadastro:
                                                snapshot.data.dataCadastro),
                                        SizedBox(height: 16),
                                        AnimalInfoCard(
                                            especie: snapshot.data.especie,
                                            porte: snapshot.data.porte,
                                            sexo: snapshot.data.sexo,
                                            faixaEtaria:
                                                snapshot.data.faixaEtaria),
                                        SizedBox(height: 16),
                                        FutureBuilder(
                                          future: _perguntas,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return QuestionAnswersCard(snapshot.data, () => _openQuestionsScreen(context));
                                            }
                                            return CircularProgressIndicator();
                                          }
                                        ),
                                        SizedBox(height: 16),
                                        AddressInfoCard(
                                          endereco: snapshot.data.endereco,
                                          onTap: () => _openAddressDetailsModal(
                                              context,
                                              snapshot.data.endereco,
                                              snapshot.data.coordinates),
                                        ),
                                        SizedBox(height: 16),
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
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Positioned(
                        right: 16,
                        top: _bodySize.height -
                            (_bodySize.height * 0.60) -
                            (_floatingActionButtonSize.height / 2),
                        child: Measurer(
                          onMeasure: (size, constraints) {
                            setState(() {
                              _floatingActionButtonSize = size;
                            });
                          },
                          child: _getFloatingActionButton(snapshot.data.userId, _interesseManifestado, snapshot.data.interessado)
                        ),
                      )
                    ],
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          )),
    );
  }
}
