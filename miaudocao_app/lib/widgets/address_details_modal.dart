import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:miaudocao_app/utils/places_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressDetailsModal extends StatefulWidget {

  final String endereco;
  final Coordinates coordinates;

  AddressDetailsModal({
    @required this.endereco,
    @required this.coordinates
  });
  
  @override
  _AddressDetailsModalState createState() => _AddressDetailsModalState();
}

class _AddressDetailsModalState extends State<AddressDetailsModal> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();
  bool _showGoogleMaps = false;

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: MarkerId('marker_1'),
        position: LatLng(widget.coordinates.latitude, widget.coordinates.longitude)
      )
    );
    Future.delayed(const Duration(milliseconds: 500), () {
    setState(() {
        _showGoogleMaps = true;
      });
    });
  }

  _openGoogleMaps(double lat, double lng) async {
    String mapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      throw 'Something went wrong.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: 25,
            left: 16, 
            right: 16, 
            bottom: 16
          ),
          child: Column(
            children: [
              Text(
                'Localização',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.endereco,
                textAlign: TextAlign.center,
              ),
            ]
          ),
        ),
        Expanded(
          child: _showGoogleMaps
            ? GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.coordinates.latitude, widget.coordinates.longitude),
                  zoom: 16
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: _markers
              )
            : Center(
                child: CircularProgressIndicator(),
              )
        ),
        TextButton(
          child: Text('Abrir no Google Maps'),
          onPressed: () => _openGoogleMaps(widget.coordinates.latitude, widget.coordinates.longitude)
        )
      ],
    );
  }
}