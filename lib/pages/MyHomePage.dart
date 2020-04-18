import 'package:complex/core/BuildSpeedDial.dart';
import 'package:complex/core/CurvePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:complex/pages/Settings.dart';
import 'package:complex/pages/TransactionList.dart';
import 'package:complex/pages/Statistics.dart';
import 'package:complex/widget/PopapDate.dart';
import 'package:complex/providers/provider.dart';
import 'package:complex/charts/DonutChart.dart';
import 'package:complex/charts/TimeLineChar.dart';
import 'package:complex/model/model.dart';
import 'package:complex/utils/UtilsFormat.dart';
import 'package:complex/constant/Querys.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool dialVisible = true;

  Future<List<Map<String, dynamic>>> gastosCategoria(String fecha) async {
    List<Map<String, dynamic>> data =
        await DbComplex().execDataTable(Querys.gastosCategoria(fecha));
    return data;
  }

  Future<List<Map<String, dynamic>>> historialGastos(String fecha) async {
    List<Map<String, dynamic>> data =
        await DbComplex().execDataTable(Querys.historialGastos(fecha));
    return data;
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
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  header(),
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

  Widget header() {
    return FadeInDown(
      duration: Duration(milliseconds: 400),
      child: Container(
        height: 225,
        width: double.infinity,
        child: CustomPaint(
          painter: CurvePainter(color: Colors.blue),
          child: Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PopapDate(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Saldo Actual:',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Consumer<MainProvider>(
                      builder: (_, snapshot, __) {
                        return Text(
                          "Gs. " + UtilsFormat.formatNumber(snapshot.saldo),
                          style: Theme.of(context).textTheme.title.copyWith(
                                fontWeight: FontWeight.normal,
                              ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Ingresos:',
                      style: Theme.of(context).textTheme.title,
                    ),
                    Spacer(),
                    Consumer<MainProvider>(
                      builder: (_, snapshot, __) {
                        return Text(
                          "Gs. " +
                              UtilsFormat.formatNumber(snapshot.ingresoTotal),
                          style: Theme.of(context).textTheme.title.copyWith(
                                fontWeight: FontWeight.normal,
                              ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Egresos:',
                      style: Theme.of(context).textTheme.title,
                    ),
                    Spacer(),
                    Consumer<MainProvider>(
                      builder: (_, snapshot, __) {
                        return Text(
                          "Gs. " +
                              UtilsFormat.formatNumber(snapshot.egresoTotal),
                          style: Theme.of(context).textTheme.title.copyWith(
                                fontWeight: FontWeight.normal,
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget gastosPorCategoria() {
    var mainProvider = Provider.of<MainProvider>(context);
    return FadeIn(
      duration: Duration(milliseconds: 400),
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          child: Container(
            width: double.infinity,
            height: 220.0,
            padding: EdgeInsets.only(
                top: 10.0, left: 10.0, right: 10.0, bottom: 0.0),
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
                  height: 150,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(left: 10),
                  child: DonutChart(
                      gastosCategoria(mainProvider.mesActualTransaction)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget frecuenciaDeGastos() {
    var mainProvider = Provider.of<MainProvider>(context);
    return FadeIn(
      duration: Duration(milliseconds: 400),
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: 220.0,
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
              Container(
                height: 170,
                width: double.infinity,
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TimeLineChar(
                    historialGastos(mainProvider.mesActualTransaction)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget metas() {
    return FadeIn(
      duration: Duration(milliseconds: 400),
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: 220.0,
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
    );
  }

  Color _appBarColor(int index) {
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
