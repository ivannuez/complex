import 'package:complex/model/model.dart';
import 'package:flutter/material.dart';
import 'package:complex/widget/ListItem.dart';
import 'package:complex/utils/UtilsFormat.dart';

class ItemTransaction extends StatelessWidget implements ListItem {
  final ItemTransactionHeader header;
  final List<ItemTransactionBody> body;
  final ItemTransactionFooter footer;

  ItemTransaction(this.header, this.body, this.footer);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.only(left: 8, right: 10, bottom: 8, top: 0),
      child: Card(
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              header,
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: body.length,
                itemBuilder: (context, index) {
                  final item = body[index];
                  return item;
                },
              ),
              //footer,
            ],
          ),
        ),
      ),
    );
  }
}

/* @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          header,
          AbsorbPointer(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: body.length,
              itemBuilder: (context, index) {
                final item = body[index];
                return item;
              },
            ),
          ),
          footer,
        ],
      ),
    );
  }
}*/

class ItemTransactionHeader extends StatelessWidget {
  final String header;

  ItemTransactionHeader(this.header);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          this.header,
          style: Theme.of(context).textTheme.subtitle,
        ),
        Divider()
      ],
    );
  }
}

class ItemTransactionBody extends StatelessWidget implements ListItem {
  final int idTransacction;
  final String descripcion;
  final Categoria categoria;
  final double monto;
  final IconData icono;
  final String tipoTransaccion;
  final VoidCallback onPress;

  ItemTransactionBody(this.idTransacction, this.descripcion, this.categoria,
      this.monto, this.icono, this.tipoTransaccion, this.onPress);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    icono,
                    color: (tipoTransaccion == 'I' ? Colors.green : Colors.red),
                    size: 20.0,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    this.descripcion,
                    style: Theme.of(context).textTheme.button.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    this.categoria.descripcion,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: Color(categoria.color)),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Gs. ' + UtilsFormat.formatNumber(this.monto),
                      style: Theme.of(context).textTheme.body1.copyWith(
                          color: (tipoTransaccion == 'I'
                              ? Colors.green
                              : Colors.red)),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class ItemTransactionFooter extends StatelessWidget implements ListItem {
  String descripcion;
  double monto;
  bool saldo = true;

  final double footerTextSize = 14;

  ItemTransactionFooter(this.descripcion, this.monto, this.saldo);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  this.descripcion,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Gs. ' + UtilsFormat.formatNumber(this.monto),
                      style: Theme.of(context).textTheme.body1.copyWith(
                          color: (this.saldo ? Colors.green : Colors.red),
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
