import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:measurer/measurer.dart';
import 'package:miaudocao_app/models/animal.dart';
import 'package:miaudocao_app/utils/places_service.dart';
import 'package:miaudocao_app/widgets/address_details_modal.dart';
import 'package:miaudocao_app/widgets/address_info_card.dart';
import 'package:miaudocao_app/widgets/animal_identification.dart';
import 'package:miaudocao_app/widgets/animal_info_card.dart';
import 'package:miaudocao_app/widgets/fullscreen_image.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/animal.dart';

class VisualizarAnimalScreen extends StatefulWidget {
  final String _animalId;
  VisualizarAnimalScreen(this._animalId);

  @override
  _VisualizarAnimalScreenState createState() => _VisualizarAnimalScreenState();
}

class _VisualizarAnimalScreenState extends State<VisualizarAnimalScreen> {
  Size _bodySize = Size(0, 0);
  Size _floatingActionButtonSize = Size(0, 0);

  final Dio _dio = Dio();
  Future<Animal> _animal;

  Future<Animal> fetchAnimal() async {
    try {
      final response = await this
          ._dio
          .get('http://localhost:3000/animais/${widget._animalId}');

      return Animal.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    _animal = fetchAnimal();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            child: GestureDetector(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      boxShadow: kElevationToShadow[4]),
                                  child: Hero(
                                    tag: 'imageHero',
                                    child: Image.memory(
                                      base64Decode(
                                          snapshot.data.foto.split(',')[1]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return FullscreenImage(snapshot.data.foto);
                                  }));
                                }),
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
                        child: FloatingActionButton.extended(
                          onPressed: () => {},
                          label: Row(
                            children: [
                              Icon(Icons.pets),
                              SizedBox(width: 10),
                              Text('Tenho interesse',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}
