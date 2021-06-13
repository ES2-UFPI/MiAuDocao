import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../models/animal.dart';
import '../utils/places_service.dart';
import 'centralized_tip_text.dart';
import 'input_button.dart';
import 'custom_textfield.dart';
import 'custom_dropdown_button.dart';
import 'search_address_modal.dart';

class AnimalForm extends StatefulWidget {
  final void Function(Animal, BuildContext) submitRegister;
  AnimalForm(this.submitRegister);

  @override
  _AnimalFormState createState() => _AnimalFormState();
}

class _AnimalFormState extends State<AnimalForm> {  

  String _fileName;
  List<PlatformFile> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.image;

  // TextField controllers
  final _nomeInputController = TextEditingController();
  final _descricaoInputController = TextEditingController();
  String _endereco;
  Coordinates _coordinates;
  String _especieSelecionada;
  String _porteSelecionado;
  String _sexoSelecionado;
  String _faixaEtariaSelecionada;
  String _foto;
  
  List<String> listaEspecies = [
    'Cachorro', 'Gato', 'Coelho'
  ];
  List<String> listaPortes = [
    'Pequeno', 'Médio', 'Grande'
  ];
  List<String> listaSexos = [
    'Macho', 'Fêmea'
  ];
  List<String> listaFaixasEtarias= [
    'Filhote', 'Jovem', 'Adulto', 'Idoso'
  ];

  void _openFileExplorer() async {
    FocusManager.instance.primaryFocus.unfocus();
    setState(() => _loadingPath = true);
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (e) {
      print(e);
    }
    if (!mounted) return;

    if (_paths == null) {
      setState(() => _loadingPath = false);
      return;
    }
    
    setState(() {
      _loadingPath = false;
      print(_paths.first.extension);
      _fileName =
          _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });

    // Pega a imagem e transforma para base64
    String mime = 'data:image/${_paths.first.extension};base64,';
    File image = File(_paths.first.path);
    List<int> imageBytes = await image.readAsBytes();
    setState(() {
      _foto = mime + base64Encode(imageBytes);
    });
  }

  _openSearchAddressModal(BuildContext context) {
    FocusManager.instance.primaryFocus.unfocus();
    showBarModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20)
        ),
      ),
      builder: (context) {
        return SearchAddressModal(_setAddressAndCoordinates);
      }
    );
  }

  _setAddressAndCoordinates(String endereco, Coordinates coordinates) {
    setState(() {
      _endereco = endereco;
      _coordinates = coordinates;
    });

    Navigator.of(context).pop();
  }

  _showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message)
      )
    );
  }

  _submitForm(BuildContext context) {
    if (_nomeInputController.text.isEmpty
      || _descricaoInputController.text.isEmpty || _foto == null
      || _especieSelecionada == null || _porteSelecionado == null
      || _sexoSelecionado == null || _faixaEtariaSelecionada == null
      || _endereco == null || _coordinates == null
    ) {
      _showSnackBar(
        context,
        'Opa! Parece que você não preecheu todas as informações.'
      );
      return;
    }

    Animal animal = Animal(
      nome: _nomeInputController.text,
      descricao: _descricaoInputController.text,
      foto: _foto,
      especie: _especieSelecionada.toLowerCase(),
      porte: _porteSelecionado.toLowerCase(),
      sexo: _sexoSelecionado.toLowerCase(),
      faixaEtaria: _faixaEtariaSelecionada.toLowerCase(),
      endereco: _endereco,
      coordinates: _coordinates
    );

    widget.submitRegister(animal, context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              child: Image.asset(
                'assets/images/cat_dog.png',
                fit: BoxFit.cover,
              )
            ),
            SizedBox(height: 16),
            CentralizedTipText(
              title: 'Identificação e informações do animal', 
              subtitle: 'Estas são as informações básicas que ajudam a identificar o animal no MiAuDoção.'
            ),
            SizedBox(height: 10),
            CustomTextField(
              hint: 'Nome do animal',
              maxLength: 50,
              controller: _nomeInputController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10),
            CustomTextField(
              hint: 'Descrição do animal',
              maxLength: 300,
              showCounter: true,
              multiline: true,
              controller: _descricaoInputController,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 10),
            InputButton(
              onTap: () => _openFileExplorer(),
              label: _loadingPath
                  ? 'Abrindo explorador...'
                  : _paths == null
                    ? _fileName == null
                      ? 'Selecionar imagem'
                      : _fileName
                    : _fileName,     
              icon: Icon(Icons.photo)
            ),
            SizedBox(height: 16),
            CentralizedTipText(
              title: 'Alguns detalhes do animal', 
              subtitle: 'Estes detalhes são para que o animal seja encontrado mais facilmente por um tutor interessado.'
            ),
            SizedBox(height: 10),
            CustomDropdownButton(
              hint: 'Espécie',
              selectedItem: _especieSelecionada,
              itemsList: listaEspecies,
              onSelected: (newValue) {
                setState(() {
                  _especieSelecionada = newValue;        
                });
              }
            ),
            SizedBox(height: 10),
            CustomDropdownButton(
              hint: 'Porte',
              selectedItem: _porteSelecionado,
              itemsList: listaPortes,
              onSelected: (newValue) {
                setState(() {
                  _porteSelecionado = newValue;        
                });
              }
            ),
            SizedBox(height: 10),
            CustomDropdownButton(
              hint: 'Sexo',
              selectedItem: _sexoSelecionado,
              itemsList: listaSexos,
              onSelected: (newValue) {
                setState(() {
                  _sexoSelecionado = newValue;        
                });
              }
            ),
            SizedBox(height: 10),
            CustomDropdownButton(
              hint: 'Faixa etária',
              selectedItem: _faixaEtariaSelecionada,
              itemsList: listaFaixasEtarias,
              onSelected: (newValue) {
                setState(() {
                  _faixaEtariaSelecionada = newValue;        
                });
              }
            ),
            SizedBox(height: 16),
            CentralizedTipText(
              title: 'Localização', 
              subtitle: 'Para facilitar ainda mais a adoção, pedimos que informe o endereço onde se encontra o animal.'
            ),
            SizedBox(height: 10), 
            InputButton(
              onTap: () => _openSearchAddressModal(context),
              label: _endereco == null ? 'Procurar endereço' : _endereco,
              icon: Icon(Icons.pin_drop),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                //style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                onPressed: () => _submitForm(context),
                child: Text(
                  'Cadastrar animal',
                  style: TextStyle(
                    fontSize: 18
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}