import 'package:flutter/material.dart';
import 'package:complex/constant/Widget.dart';
import 'package:complex/constant/Librerias.dart';
import 'package:complex/constant/Pages.dart';

class Base extends StatefulWidget {
  Base({Key key}) : super(key: key);

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int _selectedIndex = 0;
  bool dialVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appBarColor(_selectedIndex),
      body: Container(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.grey[50],
            child: _widgetOptions(_selectedIndex),
          ),
        ),
      ),
      floatingActionButton:
          BuildSpeedDial(dialVisible: dialVisible, context: context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(MaterialCommunityIcons.home),
            title: Text('Inicio'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MaterialCommunityIcons.format_list_bulleted_square),
            title: Text('Transacciones'),
          ),
          BottomNavigationBarItem(
            icon: Icon(AntDesign.barchart),
            title: Text('Estadisticas'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.ios_options),
            title: Text('Opciones'),
          ),
        ],
      ),
    );
  }

  Widget _widgetOptions(int index) {
    switch (index) {
      case 0:
        {
          return Home();
        }
      case 1:
        {
          return TransactionList(
            tipoForm: 'T',
            textForm: 'Transacciones',
          );
        }
      case 2:
        {
          return Statistics();
        }
      case 3:
        {
          return Settings();
        }
    }
    return Container();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      dialVisible = (index == 0 ? true : false);
    });
  }

  MaterialColor _appBarColor(int index) {
    if (index == 0) {
      return Colors.blue;
    } else {
      return Colors.blue;
    }
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }
}
