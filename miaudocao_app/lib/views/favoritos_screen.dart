import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:miaudocao_app/utils/configs.dart';
import 'package:miaudocao_app/widgets/animal_item.dart';

class FavoritosScreen extends StatefulWidget {
  final String userId;
  FavoritosScreen(this.userId);

  @override
  _FavoritosScreenState createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  Dio _dio = new Dio();
  bool _isLoading = false;
  Future _favoritos;

  Future _fetchFavoritos() async {
    try {
      final response = await this._dio.get('${Configs.API_URL}/favorito/${widget.userId}/all');

      return response.data;

    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _favoritos = _fetchFavoritos();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favoritos',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: FutureBuilder(
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
                  image: snapshot.data[index]['foto'],
                  nome: snapshot.data[index]['nome'],
                  descricao: snapshot.data[index]['descricao'],
                  id: snapshot.data[index]['id'],
                  userId: snapshot.data[index]['usuario_id'],
                  adotado: false);
            },
          );
        },
        future: _favoritos,
      ),
    );
  }
}