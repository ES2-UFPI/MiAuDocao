import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:miaudocao_app/utils/places_service.dart';
import 'package:miaudocao_app/widgets/centralized_tip_text.dart';
import 'package:miaudocao_app/widgets/input_button.dart';
import 'custom_textfield.dart';
import 'custom_dropdown_button.dart';
import 'search_address_modal.dart';
import 'package:dio/dio.dart';

class AnimalForm extends StatefulWidget {
  @override
  _AnimalFormState createState() => _AnimalFormState();
}

class _AnimalFormState extends State<AnimalForm> {  

  final Dio _dio = Dio();

  String _fileName;
  List<PlatformFile> _paths;
  String _directoryPath;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.image;

  // TextField controllers
  final _nomeInputController = TextEditingController();
  final _descricaoInputController = TextEditingController();

  // Atributos de um animal provisoriamente declarados aqui (sem um model)
  //String _nome;
  //String _descricao;
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
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
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
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
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
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20)
        )
      ),
      context: context,
      isScrollControlled: false,
      builder: (_) {
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

  _submitRegister() async {
    // Validação e execução da requisição POST para a MiAuDoção API
    // print('Todos os dados de um animal a ser cadastrado:');
    // print(_nomeInputController.text);
    // print(_descricaoInputController.text);
    // print(_endereco);
    // print('Lat: ${_coordinates.latitude}, Long: ${_coordinates.longitude}');
    // print(_especieSelecionada);
    // print(_porteSelecionado);
    // print(_sexoSelecionado);
    // print(_faixaEtariaSelecionada);
    // print(_foto);

    final response = await this._dio.post(
      'http://192.168.0.107:3000/animais', 
      data: json.encode({
        'nome': _nomeInputController.text,
        'descricao': _descricaoInputController.text,
        'especie': _especieSelecionada.toLowerCase(),
        'porte': _porteSelecionado.toLowerCase(),
        'sexo': _sexoSelecionado.toLowerCase(),
        'faixa_etaria': _faixaEtariaSelecionada.toLowerCase(),
        'endereco': _endereco,
        'latitude': _coordinates.latitude.toString(),
        'longitude': _coordinates.longitude.toString(),
        'foto': _foto,
      })
    );

    print(response.data);

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
            ),
            SizedBox(height: 10),
            CustomTextField(
              hint: 'Descrição do animal',
              maxLength: 300,
              showCounter: true,
              multiline: true,
              controller: _descricaoInputController,
            ),
            SizedBox(height: 10),
            InputButton(
              onTap: () => _openFileExplorer(),
              label: _loadingPath
                  ? 'Abrindo explorador...'
                  : _fileName == null ? 'Selecionar imagem' : _fileName,
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
            // Text(
            //   _coordinates == null ? '' : 'Lat: ${_coordinates.latitude}, Long: ${_coordinates.longitude}'
            // ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _submitRegister(),
              child: Text('Cadastrar animal')
            )
          ],
        ),
      ),
    );
  }
}