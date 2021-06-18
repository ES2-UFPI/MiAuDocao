import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miaudocao_app/models/usuario.dart';
import 'package:miaudocao_app/widgets/custom_textfield.dart';
import 'package:miaudocao_app/widgets/input_button.dart';

import 'centralized_tip_text.dart';
import 'custom_dropdown_button.dart';

class UserForm extends StatefulWidget {
  final void Function(Usuario, BuildContext) submitRegister;
  UserForm(this.submitRegister);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  List<String> listaEspecies = ['Cachorro', 'Gato', 'Coelho'];
  List<String> listaPortes = ['Pequeno', 'Médio', 'Grande'];
  List<String> listaSexos = ['Macho', 'Fêmea'];
  List<String> listaFaixasEtarias = ['Filhote', 'Jovem', 'Adulto', 'Idoso'];

  final _nomeInputController = TextEditingController();
  final _emailInputController = TextEditingController();
  final _telefoneInputController = TextEditingController();
  final _senhaInputController = TextEditingController();
  String _especieSelecionada;
  String _porteSelecionado;
  String _sexoSelecionado;
  String _faixaEtariaSelecionada;
  double _currentSliderValue = 1;
  String _foto;

  String _fileName;
  List<PlatformFile> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.image;

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
      || _emailInputController.text.isEmpty
      || _telefoneInputController.text.isEmpty 
      || _senhaInputController.text.isEmpty || _foto == null
      || _especieSelecionada == null || _porteSelecionado == null
      || _sexoSelecionado == null || _faixaEtariaSelecionada == null
    ) {
      _showSnackBar(
        context,
        'Opa! Parece que você não preencheu todas as informações.'
      );
      return;
    }

    Usuario usuario = Usuario(
      nome: _nomeInputController.text,
      foto: _foto,
      email: _emailInputController.text,
      telefone: _telefoneInputController.text,
      password: _senhaInputController.text,
      prefEspecie: _especieSelecionada.toLowerCase(),
      prefPorte: _porteSelecionado.toLowerCase(),
      prefSexo: _sexoSelecionado.toLowerCase(),
      prefFaixaEtaria: _faixaEtariaSelecionada.toLowerCase(),
      prefRaioBusca: _currentSliderValue.round()
    );

    widget.submitRegister(usuario, context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CentralizedTipText(
              title: 'Informações pessoais', 
              subtitle: 'Estas são as informações que identificam você no MiAuDoção.'
            ),
            SizedBox(height: 10),
            CustomTextField(
              hint: 'Nome',
              maxLength: 50,
              controller: _nomeInputController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10),
            CustomTextField(
              hint: 'E-mail',
              maxLength: 100,
              controller: _emailInputController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10),
            CustomTextField(
              hint: 'Telefone',
              maxLength: 11,
              controller: _telefoneInputController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10),
            CustomTextField(
              hint: 'Senha',
              maxLength: 100,
              controller: _senhaInputController,
              obscureText: true,
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
              title: 'Suas preferências', 
              subtitle: 'Você poderá alterá-las depois se preferir.'
            ),
            SizedBox(height: 10),
            CustomDropdownButton(
              hint: 'Preferência de espécie',
              selectedItem: _especieSelecionada,
              itemsList: listaEspecies,
              onSelected: (newValue) {
                setState(() {
                  _especieSelecionada = newValue;
                });
              },
            ),
            SizedBox(height: 10),
            CustomDropdownButton(
              hint: 'Preferência de porte',
              selectedItem: _porteSelecionado,
              itemsList: listaPortes,
              onSelected: (newValue) {
                setState(() {
                  _porteSelecionado = newValue;
                });
              },
            ),
            SizedBox(height: 10),
            CustomDropdownButton(
              hint: 'Preferência de sexo',
              selectedItem: _sexoSelecionado,
              itemsList: listaSexos,
              onSelected: (newValue) {
                setState(() {
                  _sexoSelecionado = newValue;
                });
              },
            ),
            SizedBox(height: 10),
            CustomDropdownButton(
              hint: 'Preferência de faixa-etária',
              selectedItem: _faixaEtariaSelecionada,
              itemsList: listaFaixasEtarias,
              onSelected: (newValue) {
                setState(() {
                  _faixaEtariaSelecionada = newValue;
                });
              },
            ),
            SizedBox(height: 10),
            SliderTheme(
              data: SliderThemeData(
                valueIndicatorColor: Colors.grey.shade200,
              ),
              child: Slider(
                value: _currentSliderValue,
                min: 1,
                max: 20,
                divisions: 20,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
            ),
            Text(
              'Raio de busca preferido: ${_currentSliderValue.round()} km',
              style: TextStyle(fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _submitForm(context),
              child: Text('Concluir cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}