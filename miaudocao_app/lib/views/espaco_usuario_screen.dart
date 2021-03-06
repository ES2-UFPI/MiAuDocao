import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:miaudocao_app/models/animal.dart';
import 'package:miaudocao_app/models/animal_facade.dart';
import 'package:miaudocao_app/models/usuario.dart';
import 'package:miaudocao_app/utils/app_routes.dart';
import 'package:miaudocao_app/views/cadastrar_animal_screen.dart';
import 'package:miaudocao_app/widgets/animal_item.dart';

class EspacoUsuarioScreen extends StatefulWidget {
  final Usuario connectedUser;
  EspacoUsuarioScreen({@required this.connectedUser});

  @override
  _EspacoUsuarioScreenState createState() => _EspacoUsuarioScreenState();
}

class _EspacoUsuarioScreenState extends State<EspacoUsuarioScreen> {
  Future _animais;
  bool _isLoading = true;

  Future _getUserAnimals() async {
    List<Animal> animais = await AnimalFacade.fetchUserAnimals(widget.connectedUser.id);
    setState(() => _isLoading = false);
    return animais;
  }

  void _onShowInteressados(BuildContext context, String animalId) {
    Navigator.of(context).pushNamed(AppRoutes.INTERESSADOS, arguments: animalId);
  }

  void _onShowQuestions(BuildContext context, String animalId, String userId) {
    Navigator.of(context).pushNamed(
      AppRoutes.PERGUNTAS,
      arguments: [animalId, userId, 'resposta']);
  }

  void _marcarAdotado(String animalId, BuildContext context) async {
    context.loaderOverlay.show();
    await AnimalFacade.markAnimalAsAdopted(animalId);
    context.loaderOverlay.hide();
    await _updateUserAnimals();
  }

  void _updateUserAnimals() {
    setState(() {
      _isLoading = true;
      _animais = _getUserAnimals();
    });
  }

  @override
  void initState() {
    super.initState();
    _animais = _getUserAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Meu espaço',
            style: TextStyle(
              fontWeight: FontWeight.w700
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.FAVORITOS,
                arguments: widget.connectedUser.id
              ),
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.NOTIFICACOES,
                arguments: widget.connectedUser.id
              ),
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => Navigator.of(context).pop()
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 10
              ),
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
                                    widget.connectedUser.foto.split(',')[1])))),
                      ),
                      SizedBox(width: 16),
                      Flexible(
                        child: Container(
                          //width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.connectedUser.nome,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text('No MiAuDoção desde: ' +
                                  DateFormat('dd/MM/yyyy').format(
                                      DateTime.fromMillisecondsSinceEpoch(int.parse(
                                          widget.connectedUser.dataCadastro)))),
                              SizedBox(height: 5),
                              Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text('Editar perfil',
                                        textAlign: TextAlign.center),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Meus animais',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        child: Row(
                          children: [
                            Icon(Icons.filter_alt),
                            SizedBox(width: 5),
                            Text('Filtrar')
                          ],
                        ),
                        onPressed: () => {},
                      )
                    ],
                  ),
                ],
              ),
            ),
            _isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: FutureBuilder(
                      builder: (context, snapshot) {
                        if (snapshot.hasData == false || _isLoading == true) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.data.length == 0) {
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
                                  'Você não possui nenhum animal cadastrado.',
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
                            return AnimalItem(
                              image: snapshot.data[index].foto,
                              nome: snapshot.data[index].nome,
                              descricao: snapshot.data[index].descricao,
                              id: snapshot.data[index].id,
                              userId: widget.connectedUser.id,
                              adotado: snapshot.data[index].adotado,
                              showOptions: true,
                              showInteressados: () => _onShowInteressados(context, snapshot.data[index].id),
                              showQuestions: () => _onShowQuestions(context, snapshot.data[index].id, widget.connectedUser.id),
                              marcarAdotado: () => _marcarAdotado(snapshot.data[index].id, context),
                            );
                          },
                        );
                      },
                      future: _animais,
                    ),
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Row(
            children: [
              Icon(Icons.add),
              SizedBox(
                width: 5,
              ),
              Text(
                'Cadastrar animal',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => CadastrarAnimalScreen(widget.connectedUser.id),
              ))
              .then((value) {
                _updateUserAnimals();
              })
        ),
      ),
    );
  }
}
