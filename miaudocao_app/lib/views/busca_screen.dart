import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:miaudocao_app/models/animal.dart';
import 'package:miaudocao_app/widgets/animal_item.dart';
import 'package:miaudocao_app/widgets/centralized_tip_text.dart';
import 'package:miaudocao_app/widgets/search_filters_modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BuscaScreen extends StatefulWidget {

  @override
  _BuscaScreenState createState() => _BuscaScreenState();
}

class _BuscaScreenState extends State<BuscaScreen> {
  final Dio _dio = Dio();
  String _especie = '';
  String _porte = '';
  String _sexo = '';
  String _faixaEtaria = '';
  String _ordenacao = 'Data mais recente';
  double _raio = 1;
  bool _showTip = true;

  Location _location = new Location();
  LocationData _currentLocation;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  bool _isLoading = false;

  Future _animais;

  void _updateSearch(String especie, String porte, String sexo, String faixaEtaria, String ordenacao, double raio) async {
    setState(() {
      _showTip = false;
    });

    if (especie == 'Todas') _especie = ''; else _especie = especie;
    if (porte == 'Todos') _porte = ''; else _porte = porte;
    if (sexo == 'Ambos') _sexo = ''; else _sexo = sexo;
    if (faixaEtaria == 'Todas') _faixaEtaria = ''; else _faixaEtaria = faixaEtaria;
    _ordenacao = ordenacao;
    _raio = raio;

    Navigator.pop(context);

    setState(() {
      _animais = null;
      _animais = _fetchSearch();
    });
    
  }

  Future _fetchSearch() async {
    setState(() => _isLoading = true);
    try {
      final response = await this._dio.get(
        'https://miaudocao.herokuapp.com/busca',
        queryParameters: {
          'especie': _especie,
          'porte': _porte,
          'sexo': _sexo,
          'faixa': _faixaEtaria,
          'lat': _currentLocation.latitude.toString(),
          'lng': _currentLocation.longitude.toString(),
          'raio': _raio
        }
      );
      final List<Animal> animais = (response.data as List)
          .map((item) => Animal.fromJson(item)).toList();

      if (_ordenacao == 'Data mais recente') {
        animais.sort((a,b) => b.data.compareTo(a.data));
      } else if (_ordenacao == 'Data mais antiga') {
        animais.sort((a,b) => a.data.compareTo(b.data));
      } else if (_ordenacao == 'Mais próximo') {
        print('MAIS PRÓXIMO');
        animais.sort((a,b) => a.distancia.compareTo(b.distancia));
      } else if (_ordenacao == 'Mais distante') {
        print('MAIS DISTANTE');
        animais.sort((a,b) => b.distancia.compareTo(a.distancia));
      }

      setState(() => _isLoading = false);

      return animais;
    } catch (e) {
      print(e);
    }
    return null;
  }

  void _getLocation() async {
    setState(() {
      _isLoading = true;
    });
    initialize();
    _currentLocation = await _location.getLocation();
    if (_currentLocation == null) {
      return;
    }
   
    setState(() {
       _animais = _fetchSearch();
      _isLoading = false;
    });   
    print("CurrentLocation: $_currentLocation");
  }

  Future<void> initialize() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void _openFiltersModal(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20)
        ),
      ),
      builder: (_) {
        return SearchFiltersModal(
          onSubmitList: _updateSearch,
          especie: _especie,
          porte: _porte,
          sexo: _sexo,
          faixaEtaria: _faixaEtaria,
          raio: _raio,
          showOrdernar: true,
          ordenacao: _ordenacao,
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Busca'),
      ),
      body: Column(
        children: [
          if (_showTip) Padding(
            padding: const EdgeInsets.all(16),
            child: CentralizedTipText(
              title: 'Exibindo animais nas suas redondezas',
              subtitle: 'Você pode aplicar filtros para refinar sua busca.',
            ),
          ),
          Expanded(
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
                        SizedBox(height: 10,),
                        Text(
                          'Parece que não há nenhum resultado com os filtros atuais. Tente filtrar a busca.',
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return AnimalItem(
                      image: snapshot.data[index].foto,
                      nome: snapshot.data[index].nome,
                      descricao: snapshot.data[index].descricao,
                      id: snapshot.data[index].id
                    );
                  },
                );
              },
              future: _animais,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_alt),
        onPressed: () => _openFiltersModal(context)
      ),
    );
  }
}