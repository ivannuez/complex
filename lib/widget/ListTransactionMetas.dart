import 'package:complex/model/model.dart';
import 'package:complex/utils/UtilsFormat.dart';
import 'package:complex/widget/NotData.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class ListTransactionMetas extends StatelessWidget {
  final Future<List<DetallesMeta>> list;

  ListTransactionMetas({this.list});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: list,
      builder: (context, detalleSnap) {
        if (detalleSnap.connectionState == ConnectionState.waiting) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        } else {
          if (detalleSnap.data == null || detalleSnap.data.isEmpty) {
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: NotData(),
            );
          } else {
            return FadeIn(
              duration: Duration(milliseconds: 400),
              child: ListView.builder(
                itemCount: detalleSnap.data.length,
                itemBuilder: (context, index) {
                  DetallesMeta detalle = detalleSnap.data[index];
                  return ListTile(
                    contentPadding: EdgeInsets.all(0),
                    dense: true,
                    leading: Text(
                      detalle.fecha,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    trailing: Text(
                      UtilsFormat.formatNumber(detalle.monto) + ' Gs.',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Colors.green,
                          ),
                    ),
                  );
                },
              ),
            );
          }
        }
      },
    );
  }
}
