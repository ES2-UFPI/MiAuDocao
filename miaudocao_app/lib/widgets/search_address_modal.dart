import 'package:flutter/material.dart';
import 'package:miaudocao_app/widgets/custom_textfield.dart';
import '../utils/places_service.dart';

class SearchAddressModal extends StatefulWidget {
  final void Function(String, Coordinates) onSelectAddress;
  SearchAddressModal(this.onSelectAddress);

  @override
  _SearchAddressModalState createState() => _SearchAddressModalState();
}

class _SearchAddressModalState extends State<SearchAddressModal> {
  AutocompleteApi _placeApi = AutocompleteApi.instance;
  DetailsApi _detailsApi = DetailsApi.instance;
  bool searching = false;
  List<Place> _predictions = [];
  Coordinates _coordinates;

  _inputOnChanged(String query) {
    setState(() {
      searching = true;
    });
    if (query.trim().length > 2) {
      _search(query);
    } else {
      if (searching || _predictions.length > 0) {
        setState(() {
          searching = false;
          _predictions = [];  
        });
      }
    }
  }

  _search(String query) {
    _placeApi
        .searchPredictions(query)
        .asStream()
        .listen((List<Place> predictions) {
          if (predictions != null) {
            setState(() {
              searching = false;
              _predictions = predictions ?? [];
            });
            //print('Resultados: ${predictions.length}');
          }
        });
  }

  _getDetails(String description, String placeId) {
    //print(placeId);
    _detailsApi
        .getCoordinates(placeId)
        .asStream()
        .listen((Coordinates coordinates) {
          if (coordinates != null) {
            setState(() {
              _coordinates = coordinates ?? null;
              widget.onSelectAddress(description, _coordinates);    
            });
          }
        });
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
                'Buscar endereço',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Selecione o endereço exato ou o mais próximo possível de onde se encontra o animal.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              CustomTextField(
                hint: 'Digite o endereço',
                maxLength: 50,
                suffixIcon: Icon(Icons.search),
                onChanged: this._inputOnChanged,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: searching
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: _predictions.length,
                  itemBuilder: (_, i) {
                    final Place item = _predictions[i];
                    //print(item.description);
                    return ListTile(
                      title: Text(item.description),
                      leading: Icon(Icons.location_on),
                      onTap: () => _getDetails(item.description, item.placeId),
                    );
                  },
                )
          ),
        )
      ],
    );
  }
}