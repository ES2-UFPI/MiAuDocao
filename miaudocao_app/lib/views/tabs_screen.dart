import 'package:flutter/material.dart';
import 'package:miaudocao_app/views/busca_screen.dart';
import 'package:miaudocao_app/views/espaco_usuario_screen.dart';
import 'package:miaudocao_app/views/explorar_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedScreenIndex = 0;
  List<Map<String, Object>> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      {
        'title': 'MiAuDoção',
        'screen': ExplorarScreen()
      },
      {
        'title': 'Busca',
        'screen': BuscaScreen()
      },
      {
        'title': 'Meu espaço',
        'screen': EspacoUsuarioScreen()
      }
    ];
  }

  _selectScreen(int index) {
    setState(() {
    _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     _screens[_selectedScreenIndex]['title'],
      //     style: TextStyle,
      //   ),
      // ),
      body: _screens[_selectedScreenIndex]['screen'],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Explorar'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Busca'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Meu espaço'
          )
        ],
      ),
    );
  }
}