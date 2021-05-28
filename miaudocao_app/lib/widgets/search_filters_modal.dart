import 'package:flutter/material.dart';
import 'package:miaudocao_app/widgets/centralized_tip_text.dart';

import 'custom_dropdown_button.dart';

class SearchFiltersModal extends StatefulWidget {

  final Function(String, String, String, String, double) onSubmitMap;
  final Function(String, String, String, String, String, double) onSubmitList;
  final String especie;
  final String porte;
  final String sexo;
  final String faixaEtaria;
  final double raio;
  final bool showOrdernar;
  final String ordenacao;

  SearchFiltersModal({
    this.onSubmitMap,
    this.onSubmitList,
    @required this.especie,
    @required this.porte,
    @required this.sexo,
    @required this.faixaEtaria,
    @required this.raio,
    @required this.showOrdernar,
    this.ordenacao
  });

  @override
  _SearchFiltersModalState createState() => _SearchFiltersModalState();
}

class _SearchFiltersModalState extends State<SearchFiltersModal> {
  String _especieSelecionada;
  String _porteSelecionado;
  String _sexoSelecionado;
  String _faixaEtariaSelecionada;
  String _ordenacaoSelecionada;
  double _currentSliderValue = 1;

  List<String> listaEspecies = [
    'Todas', 'Cachorro', 'Gato', 'Coelho'
  ];

  List<String> listaPortes = [
    'Todos', 'Pequeno', 'Médio', 'Grande'
  ];

  List<String> listaSexos = [
    'Ambos', 'Macho', 'Fêmea'
  ];

  List<String> listaFaixasEtarias= [
    'Todas', 'Filhote', 'Jovem', 'Adulto', 'Idoso'
  ];

  List<String> listaOpcoesOrdenacao = [
    'Data mais recente', 'Data mais antiga', 'Mais próximo', 'Mais distante'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.especie == '') _especieSelecionada = 'Todas'; else _especieSelecionada = widget.especie;
    if (widget.porte == '') _porteSelecionado = 'Todos'; else _porteSelecionado = widget.porte;
    if (widget.sexo == '') _sexoSelecionado = 'Ambos'; else _sexoSelecionado = widget.sexo;
    if (widget.faixaEtaria == '') _faixaEtariaSelecionada = 'Todas'; else _faixaEtariaSelecionada = widget.faixaEtaria;
    _ordenacaoSelecionada = widget.ordenacao;
    _currentSliderValue = widget.raio;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CentralizedTipText(
            title: 'Filtrar busca',
            subtitle: 'Escolha os parâmetros que deseja exibir.'
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: Text(
              'Espécie',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ),
          SizedBox(height: 5),
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
          Container(
            width: double.infinity,
            child: Text(
              'Porte',
              style: TextStyle(fontWeight: FontWeight.bold)
            )
          ),
          SizedBox(height: 5),
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
          Container(
            width: double.infinity,
            child: Text(
              'Sexo',
              style: TextStyle(fontWeight: FontWeight.bold)
            )
          ),
          SizedBox(height: 5),
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
          Container(
            width: double.infinity,
            child: Text(
              'Faixa etária',
              style: TextStyle(fontWeight: FontWeight.bold)
            )
          ),
          SizedBox(height: 5),
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
          if (widget.showOrdernar) Container(
            child: Column(
              children: [
                SizedBox(height: 10),
                  Container(
                  width: double.infinity,
                  child: Text(
                    'Ordernar por',
                    style: TextStyle(fontWeight: FontWeight.bold)
                  )
                ),
                SizedBox(height: 5),
                CustomDropdownButton(
                  hint: 'Ordenar por data',
                  selectedItem: _ordenacaoSelecionada,
                  itemsList: listaOpcoesOrdenacao,
                  onSelected: (newValue) {
                    setState(() {
                      _ordenacaoSelecionada = newValue;        
                    });
                  }
                ),
              ],
            ),
          ) else Container(),
          SizedBox(height: 10),
          SliderTheme(
            data: SliderThemeData(
              valueIndicatorColor: Colors.grey.shade200
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
            'Raio de busca: ${_currentSliderValue.round()} km',
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text('Aplicar'),
            onPressed: () => 
              !widget.showOrdernar 
                ? widget
                    .onSubmitMap(_especieSelecionada, _porteSelecionado,
                    _sexoSelecionado, _faixaEtariaSelecionada, _currentSliderValue)
                : widget
                    .onSubmitList(_especieSelecionada, _porteSelecionado,
                    _sexoSelecionado, _faixaEtariaSelecionada, _ordenacaoSelecionada,
                    _currentSliderValue)
          )
        ],
      ),
    );
  }
}