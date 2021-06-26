import 'package:flutter/material.dart';
import 'package:miaudocao_app/models/usuario.dart';
import 'package:miaudocao_app/views/busca_screen.dart';
import 'package:miaudocao_app/views/espaco_usuario_screen.dart';
import 'package:miaudocao_app/views/explorar_screen.dart';

class TabsScreen extends StatefulWidget {
  final Usuario connectedUser;
  TabsScreen(this.connectedUser);

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
      {'title': 'MiAuDoção', 'screen': ExplorarScreen(connectedUserId: widget.connectedUser.id)},
      {
        'title': 'Busca',
        'screen': BuscaScreen(connectedUserId: widget.connectedUser.id)
      },
      {
        'title': 'Meu espaço',
        'screen': EspacoUsuarioScreen(connectedUser: widget.connectedUser)
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
      body: _screens[_selectedScreenIndex]['screen'],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Busca'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'Meu espaço')
        ],
      ),
    );
  }
}
