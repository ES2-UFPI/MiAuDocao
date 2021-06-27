import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:miaudocao_app/models/animal.dart';
import 'package:miaudocao_app/utils/app_routes.dart';
import 'package:miaudocao_app/utils/configs.dart';
import 'package:miaudocao_app/widgets/search_filters_modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ExplorarScreen extends StatefulWidget {
  final String connectedUserId;
  ExplorarScreen({this.connectedUserId});

  @override
  _ExplorarScreenState createState() => _ExplorarScreenState();
}

const double CAMERA_ZOOM = 16;
const LatLng SOURCE_LOCATION = LatLng(-5.090717, -42.817781);

class _ExplorarScreenState extends State<ExplorarScreen> {
  final Dio _dio = Dio();
  // Map and location attributes
  Location _location = new Location();
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();
  Set<Circle> _circles = HashSet<Circle>();
  LocationData _currentLocation;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  CameraPosition _center = CameraPosition(target: SOURCE_LOCATION, zoom: CAMERA_ZOOM);
  bool _isLoading = false;
  int _circleCounter = 0;
  double _radius = 1;

  BitmapDescriptor _customMarker;
  _getCustomMarker() async {
    _customMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 'assets/images/marker.png');
  }

  void _setMarkers(LatLng point, String id) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(id),
          position: point,
          icon: _customMarker,
          onTap: () => 
              Navigator.of(context).pushNamed(          
                AppRoutes.VISUALIZAR_ANIMAL,
                arguments: [id, widget.connectedUserId]
              ),
          consumeTapEvents: true
        )
      );
    });
  }

  void _setCircles(LatLng point) {
    final String circleId = 'circle_$_circleCounter';
    _circleCounter++;
    setState(() {
      _circles.add(Circle(
        circleId: CircleId(circleId),
        center: point,
        radius: _radius * 1000,
        fillColor: Colors.amberAccent.withOpacity(0.2),
        strokeWidth: 1,
        strokeColor: Colors.amberAccent
      ));
      _center = CameraPosition(
        target: LatLng(_currentLocation.latitude, _currentLocation.longitude),
        zoom: _getZoomLevel(_radius * 1000)
      );
    });
  }

  double _getZoomLevel(double radius) {
    double zoomLevel = 11;
    if (radius > 0) {
      double radiusElevated = radius + radius / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 16.4 - log(scale) / log(2);
    }
    zoomLevel = num.parse(zoomLevel.toStringAsFixed(2));

    return zoomLevel;
  }

  String _especie = '';
  String _porte = '';
  String _sexo = '';
  String _faixaEtaria = '';

  void _updateSearch(String especie, String porte, String sexo, String faixaEtaria, double raio) async {
    if (especie == 'Todas') _especie = ''; else _especie = especie;
    if (porte == 'Todos') _porte = ''; else _porte = porte;
    if (sexo == 'Ambos') _sexo = ''; else _sexo = sexo;
    if (faixaEtaria == 'Todas') _faixaEtaria = ''; else _faixaEtaria = faixaEtaria;
    _radius = raio;
    
    Navigator.pop(context);
    _fetchSearch();
  }

  Future<void> _fetchSearch() async {
    try {
      final response = await this._dio.get(
        '${Configs.API_URL}/busca',
        queryParameters: {
          'especie': _especie,
          'porte': _porte,
          'sexo': _sexo,
          'faixa': _faixaEtaria,
          'lat': _currentLocation.latitude.toString(),
          'lng': _currentLocation.longitude.toString(),
          'raio': _radius
        }
      );
      final List<Animal> animais = (response.data as List)
          .map((item) => Animal.fromJson(item)).toList();
      _markers.clear();
      for (var i=0; i<animais.length; i++) {
        print(animais[i].endereco);
        _setMarkers(
          LatLng(animais[i].coordinates.latitude, animais[i].coordinates.longitude),
          animais[i].id
        );
      }
      print(_currentLocation.latitude);
      _circles.clear();
      _setCircles(LatLng(_currentLocation.latitude, _currentLocation.longitude));
      _moveCamera();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _moveCamera() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_center));
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
    _center = CameraPosition(
      target: LatLng(_currentLocation.latitude, _currentLocation.longitude),
      zoom: _getZoomLevel(_radius * 1000)
    );

    await _fetchSearch();
    setState(() {
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
          onSubmitMap: _updateSearch,
          especie: _especie,
          porte: _porte,
          sexo: _sexo,
          faixaEtaria: _faixaEtaria,
          raio: _radius,
          showOrdernar: false,
        );
      }
    );
  }

  @override
  void initState() {
    //print(_location);
    super.initState();
    _getCustomMarker();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoading
      ? Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _center,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              markers: _markers,
              circles: _circles,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_alt),
                      SizedBox(width: 10,),
                      Text('Filtrar busca')
                    ],
                  ),
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  onPressed: () => _openFiltersModal(context),
                ),
              ),
            ),
            _markers.length == 0
              ? Positioned(
                  top: MediaQuery.of(context).padding.top,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
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
                      ),
                    ),
                  )
                )
              : Container()
          ], 
        )
      : Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Buscando sua localização...')
            ],
          ),
        );
  }
}