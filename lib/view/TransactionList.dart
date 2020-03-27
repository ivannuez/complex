import 'dart:collection';
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
import 'package:complex/core/MyAppbar.dart';
import 'package:animate_do/animate_do.dart';

class TransactionList extends StatefulWidget {
  TransactionList({Key key, this.tipoForm, this.textForm}) : super(key: key);

  final String tipoForm;
  final String textForm;

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  ListTransaction list;
  double egresosMes = 0;
  double ingresosMes = 0;
  double balanceMes = 0;
  double saldoActual = 0;

  void initState() {
    super.initState();
    initializeDateFormatting('es', null);
    list = ListTransaction(list: getDetalleCuenta());
  }

  Future<Cuenta> getCuenta() async {
    return await Cuenta().select().idCuenta.equals(1).toSingle();
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
          preferredSize: const Size.fromHeight(15.0),
          child: ICircularBottom(
            height: 15,
            radius: 20,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          sumaryTransaction(),
          Divider(),
          listTransaction(),
        ],
      ),
    );
  }

  Widget listTransaction() {
    return Container(
      child: Flexible(child: this.list),
    );
  }

  Widget sumaryTransaction() {
    return FutureBuilder(
      future: getCuenta(),
      builder: (context, cuentaSnap) {
        if (cuentaSnap.connectionState != ConnectionState.done) {
          return Container();
        } else {
          return FadeIn(
            duration: Duration(milliseconds: 400),
            child: Container(
              padding: EdgeInsets.only(bottom: 0, left: 10, right: 10, top: 0),
              child: Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Saldo Actual:',
                        style: Theme.of(context).textTheme.caption.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Gs. ' +
                            UtilsFormat.formatNumber(cuentaSnap.data.saldo),
                        style: Theme.of(context).textTheme.title.copyWith(
                            color: (cuentaSnap.data.saldo >= 0
                                ? Colors.green
                                : Colors.red)),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Ingreso del Mes:',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Gs. ' + UtilsFormat.formatNumber(ingresosMes),
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(color: Colors.green),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Egresos del Mes:',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Gs. ' + UtilsFormat.formatNumber(egresosMes),
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(color: Colors.red),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Balance del Mes:',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Gs. ' + UtilsFormat.formatNumber(balanceMes),
                            style: Theme.of(context).textTheme.body1.copyWith(
                                  color: (balanceMes >= 0
                                      ? Colors.green
                                      : Colors.red),
                                ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<List<ItemTransaction>> getDetalleCuenta() async {
    var mainProvider = Provider.of<MainProvider>(context, listen: false);
    List<DetallesCuenta> detalleList = await DetallesCuenta()
        .select()
        .cuentasIdCuenta
        .equals((mainProvider.cuentaId == null ? 1 : mainProvider.cuentaId))
        //.and
        //.fecha
        //.startsWith(new DateFormat('y-MM').format(new DateTime.now()))
        .orderByDesc("idDetalleCuenta")
        .orderByDesc("fecha")
        .toList();

    List<ItemTransaction> listItem = new List<ItemTransaction>();
    Map map = new LinkedHashMap<String, ItemTransaction>();

    try {
      for (var i = 0; i < detalleList.length; i++) {
        DetallesCuenta detalle = detalleList[i];

        if (detalle.tipoTransaccion == 'I') {
          ingresosMes = ingresosMes + detalle.monto;
        }
        if (detalle.tipoTransaccion == 'E') {
          egresosMes = egresosMes + detalle.monto;
        }

        String fecha = detalle.fecha;

        if (!map.containsKey(fecha)) {
          ItemTransactionHeader itemTransactionHeader =
              new ItemTransactionHeader(
                  DateFormat("EEEE, dd", "es").format(DateTime.parse(fecha)));

          List<ItemTransactionBody> body = new List<ItemTransactionBody>();
          ItemTransactionBody itemBody = new ItemTransactionBody(
              detalle.descripcion,
              await detalle.getCategoria(),
              detalle.monto,
              (detalle.tipoTransaccion == 'I'
                  ? Icons.arrow_upward
                  : Icons.arrow_downward),
              detalle.tipoTransaccion);
          body.add(itemBody);

          ItemTransactionFooter itemTransactionFooter =
              new ItemTransactionFooter(
                  "Saldo al final del día",
                  detalle.saldoEnFecha,
                  (detalle.saldoEnFecha > 0 ? true : false));

          ItemTransaction item = new ItemTransaction(
              itemTransactionHeader, body, itemTransactionFooter);

          map[fecha] = item;
        } else {
          ItemTransactionBody itemBody = new ItemTransactionBody(
              detalle.descripcion,
              await detalle.getCategoria(),
              detalle.monto,
              (detalle.tipoTransaccion == 'I'
                  ? Icons.arrow_upward
                  : Icons.arrow_downward),
              detalle.tipoTransaccion);
          ItemTransaction item = map[fecha];
          item.body.add(itemBody);
        }
      }

      //Pasamos de un Map a List
      map.forEach((k, value) {
        listItem.add(value);
      });

      balanceMes = ingresosMes - egresosMes;
      setState(() {});
    } catch (e) {
      print(e);
    }
    return listItem;
  }
}
