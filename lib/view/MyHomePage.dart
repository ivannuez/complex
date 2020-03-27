import 'package:flutter/material.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:complex/view/Settings.dart';
import 'package:complex/view/TransactionList.dart';
import 'package:complex/view/Statistics.dart';
import 'package:complex/view/PrincipalForm.dart';
import 'package:complex/providers/provider.dart';
import 'package:complex/charts/Donut.dart';
import 'package:complex/model/model.dart';
import 'package:complex/utils/UtilsFormat.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:animate_do/animate_do.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool dialVisible = true;

  getData() async {}

  Widget _widgetOptions(int index) {
    switch (index) {
      case 0:
        {
          return FutureBuilder(
            future: getData(),
            builder: (context, main) {
              if (main.connectionState != ConnectionState.done) {
                return Center(
                  child: Container(),
                );
              } else {
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        header(),
                        SizedBox(
                          height: 20.0,
                        ),
                        gastosPorCategoria(),
                        SizedBox(
                          height: 20.0,
                        ),
                        frecuenciaDeGastos(),
                        SizedBox(
                          height: 20.0,
                        ),
                        metas(),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appBarColor(_selectedIndex),
      body: Container(
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: _widgetOptions(_selectedIndex),
          ),
        ),
      ),
      floatingActionButton: buildSpeedDial(),
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

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      overlayColor: Colors.white,
      overlayOpacity: 0.7,
      visible: dialVisible,
      curve: Curves.easeIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.arrow_downward, color: Colors.white),
          backgroundColor: Colors.red,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrincipalForm(
                  tipoForm: 'E',
                  textForm: 'Gasto',
                ),
              ),
            );
          },
          label: 'Egresos',
          labelStyle:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.red,
        ),
        SpeedDialChild(
          child: Icon(Icons.arrow_upward, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrincipalForm(
                  tipoForm: 'I',
                  textForm: 'Ingreso',
                ),
              ),
            );
          },
          label: 'Ingresos',
          labelStyle:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.green,
        ),
      ],
    );
  }

  Widget header() {
    return FadeIn(
      duration: Duration(milliseconds: 400),
      child: Container(
        width: double.infinity,
        height: 235.0,
        padding:
            EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 0.0),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5.0,
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.only(top: 30.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    "Diciembre ",
                    textScaleFactor: 1.5,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Saldo actual:",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Consumer<MainProvider>(
                    builder: (_, snapshot, __) {
                      return Text(
                        "Gs. " + UtilsFormat.formatNumber(snapshot.saldo),
                        textScaleFactor: 1.9,
                      );
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.green,
                                  size: 20.0,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Ingresos"),
                                    Consumer<MainProvider>(
                                      builder: (_, snapshot, __) {
                                        return Text(
                                          "Gs. " +
                                              UtilsFormat.formatNumber(
                                                  snapshot.ingresoTotal),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.red,
                                  size: 20.0,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Egresos",
                                    ),
                                    Consumer<MainProvider>(
                                      builder: (_, snapshot, __) {
                                        return Text(
                                          "Gs. " +
                                              UtilsFormat.formatNumber(
                                                  snapshot.egresoTotal),
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          /*Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.brightness_1,
                                        color: Colors.blue,
                                        size: 10.0,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Deducir IRP"),
                                          Text("GS 6.500.000")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.brightness_1,
                                        color: Colors.blue,
                                        size: 10.0,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Declarar IRP"),
                                          Text("GS 2.500.000")
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.brightness_1,
                                        color: Colors.blue,
                                        size: 10.0,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Ingreso Anual"),
                                          Text("GS 2.500.000")
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),*/
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget gastosPorCategoria() {
    return FadeIn(
      duration: Duration(milliseconds: 400),
      child: Container(
        width: double.infinity,
        height: 235.0,
        padding:
            EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 0.0),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5.0,
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Gastos por Categoria",
                  style: Theme.of(context).textTheme.subtitle,
                ),
                Divider(),
                Container(
                  height: 170,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: DatumLegendWithMeasures.withSampleData(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget frecuenciaDeGastos() {
    return FadeIn(
      duration: Duration(milliseconds: 400),
      child: Container(
        width: double.infinity,
        height: 235.0,
        padding:
            EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 0.0),
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 5.0,
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Frecuencia de Gastos",
                  style: Theme.of(context).textTheme.subtitle,
                ),
                Divider(),
                Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget metas() {
    return FadeIn(
      duration: Duration(milliseconds: 400),
      child: Container(
        width: double.infinity,
        height: 235.0,
        padding:
            EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 0.0),
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 5.0,
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Metas",
                  style: Theme.of(context).textTheme.subtitle,
                ),
                Divider(),
                Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _appBarColor(int index) {
    if (index == 0) {
      return Colors.white;
    } else {
      return Colors.blue;
    }
  }
}