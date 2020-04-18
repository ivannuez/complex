import 'dart:collection';
import 'package:complex/pages/PrincipalForm.dart';
import 'package:complex/widget/PopapDate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:complex/providers/provider.dart';
import 'package:complex/widget/ListTransaction.dart';
import 'package:complex/widget/ItemTransaction.dart';
import 'package:complex/model/model.dart';
import 'package:complex/utils/UtilsFormat.dart';
import 'package:complex/core/ICircularBottom.dart';
import 'package:animate_do/animate_do.dart';

class TransactionList extends StatefulWidget {
  TransactionList({Key key, this.tipoForm, this.textForm}) : super(key: key);

  final String tipoForm;
  final String textForm;

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  void initState() {
    super.initState();
    initializeDateFormatting('es', null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text('Transacciones'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Buscar',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Opciones',
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Column(
            children: <Widget>[
              PopapDate(),
              SizedBox(
                height: 15,
              ),
              ICircularBottom(
                height: 15,
                radius: 20,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            sumaryTransaction(),
            listTransaction(),
          ],
        ),
      ),
    );
  }

  Widget sumaryTransaction() {
    return FutureBuilder(
      future: balanceMes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        } else {
          return FadeIn(
            duration: Duration(milliseconds: 400),
            child: Container(
              padding: EdgeInsets.only(bottom: 0, left: 10, right: 10, top: 0),
              child: Column(
                children: <Widget>[
                  /*Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Saldo Actual:',
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      Consumer<MainProvider>(
                        builder: (_, snapshot, __) {
                          return Text(
                            'Gs. ' + UtilsFormat.formatNumber(snapshot.saldo),
                            style: Theme.of(context)
                                .textTheme
                                .headline
                                .copyWith(
                                    color: (snapshot.saldo >= 0
                                        ? Colors.green
                                        : Colors.red)),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Ingreso del Mes:',
                            style: Theme.of(context).textTheme.body2.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Gs. ' +
                                UtilsFormat.formatNumber(
                                    snapshot.data["ingresos"]),
                            style: Theme.of(context)
                                .textTheme
                                .subhead
                                .copyWith(color: Colors.green),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Egresos del Mes:',
                            style: Theme.of(context).textTheme.body2.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Gs. ' +
                                UtilsFormat.formatNumber(
                                    snapshot.data["egresos"]),
                            style: Theme.of(context)
                                .textTheme
                                .subhead
                                .copyWith(color: Colors.red),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Balance del Mes:',
                            style: Theme.of(context).textTheme.body2.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Gs. ' +
                                UtilsFormat.formatNumber(
                                    snapshot.data["balance"]),
                            style: Theme.of(context).textTheme.subhead.copyWith(
                                  color: (snapshot.data["balance"] >= 0
                                      ? Colors.green
                                      : Colors.red),
                                ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget listTransaction() {
    return Expanded(
      child: ListTransaction(list: getDetalleCuenta()),
    );
  }

  Future<Map<String, int>> balanceMes() async {
    var mainProvider = Provider.of<MainProvider>(context);
    Map<String, dynamic> data = new Map<String, int>();
    int ingresos = 0;
    int egresos = 0;
    int balance = 0;
    List<DetallesCuenta> detalleList = await DetallesCuenta()
        .select()
        .cuentasIdCuenta
        .equals(mainProvider.cuentaId)
        .and
        .fecha
        .startsWith(mainProvider.mesActualTransaction)
        .orderByDesc("fecha")
        .toList();

    for (DetallesCuenta detalle in detalleList) {
      if (detalle.tipoTransaccion == 'I') {
        ingresos = ingresos + detalle.monto.toInt();
      }
      if (detalle.tipoTransaccion == 'E') {
        egresos = egresos + detalle.monto.toInt();
      }
    }
    balance = ingresos - egresos;
    data["ingresos"] = ingresos;
    data["egresos"] = egresos;
    data["balance"] = balance;
    return data;
  }

  Future<List<ItemTransaction>> getDetalleCuenta() async {
    var mainProvider = Provider.of<MainProvider>(context);
    List<DetallesCuenta> detalleList = await DetallesCuenta()
        .select()
        .cuentasIdCuenta
        .equals((mainProvider.cuentaId == null ? 1 : mainProvider.cuentaId))
        .and
        .fecha
        .startsWith(mainProvider.mesActualTransaction)
        .orderByDesc("fecha")
        .toList();

    List<ItemTransaction> listItem = new List<ItemTransaction>();
    Map map = new LinkedHashMap<String, ItemTransaction>();

    try {
      for (var i = 0; i < detalleList.length; i++) {
        DetallesCuenta detalle = detalleList[i];
        String fecha = detalle.fecha;

        if (!map.containsKey(fecha)) {
          ItemTransactionHeader itemTransactionHeader =
              new ItemTransactionHeader(
                  DateFormat("EEEE, dd", "es").format(DateTime.parse(fecha)));

          List<ItemTransactionBody> body = new List<ItemTransactionBody>();
          ItemTransactionBody itemBody = new ItemTransactionBody(
            detalle.idDetalleCuenta,
            detalle.descripcion,
            await detalle.getCategoria(),
            detalle.monto,
            (detalle.tipoTransaccion == 'I'
                ? Icons.arrow_upward
                : Icons.arrow_downward),
            detalle.tipoTransaccion,
            () {
              detalle.tipoTransaccion == 'E'
                  ? goForm('E', 'Gasto', detalle)
                  : goForm('I', 'Ingreso', detalle);
            },
          );
          body.add(itemBody);

          ItemTransactionFooter itemTransactionFooter =
              new ItemTransactionFooter(
            "Saldo al final del día",
            1000000,
            (1000000 > 0 ? true : false),
          );

          ItemTransaction item = new ItemTransaction(
              itemTransactionHeader, body, itemTransactionFooter);

          map[fecha] = item;
        } else {
          ItemTransactionBody itemBody = new ItemTransactionBody(
            detalle.idDetalleCuenta,
            detalle.descripcion,
            await detalle.getCategoria(),
            detalle.monto,
            (detalle.tipoTransaccion == 'I'
                ? Icons.arrow_upward
                : Icons.arrow_downward),
            detalle.tipoTransaccion,
            () {
              detalle.tipoTransaccion == 'E'
                  ? goForm('E', 'Gasto', detalle)
                  : goForm('I', 'Ingreso', detalle);
            },
          );
          ItemTransaction item = map[fecha];
          item.body.add(itemBody);
        }
      }

      //Pasamos de un Map a List
      map.forEach((k, value) {
        listItem.add(value);
      });
    } catch (e) {
      print(e);
    }
    return listItem;
  }

  void goForm(String type, String title, DetallesCuenta detalle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrincipalForm(
          tipoForm: type,
          textForm: title,
          editing: true,
        ),
        settings: RouteSettings(
          arguments: detalle,
        ),
      ),
    );
  }
}
