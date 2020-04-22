import 'package:complex/widget/HeaderHome.dart';
import 'package:flutter/material.dart';
import 'package:complex/providers/provider.dart';
import 'package:complex/constant/Widget.dart';
import 'package:complex/constant/Librerias.dart';
import 'package:complex/constant/Charts.dart';
import 'package:complex/constant/Utils.dart';
import 'package:complex/model/facade.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String fecha;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es', null);
    fecha = (new DateFormat("yyyy-MM").format(new DateTime.now()));
  }

  void updateFecha(String dato) {
    if (dato.isNotEmpty) {
      setState(() {
        fecha = dato;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
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
        ),
      ),
    );
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
                PopapDate(
                  date: DateTime.parse(fecha + "-01"),
                  onPress: updateFecha,
                ),
                SizedBox(
                  height: 10,
                ),
                HeaderHome(
                  list: Facade.cuentaSaldo(fecha),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget gastosPorCategoria() {
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
                  child: DonutChart(Facade.gastosCategoria(fecha)),
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
                child: TimeLineChar(Facade.historialGastos(fecha)),
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
              Expanded(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: NotData(
                    child: FlatButton(
                      textColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.add),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Metas'),
                          SizedBox(
                            width: 25,
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}