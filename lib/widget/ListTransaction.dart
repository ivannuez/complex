import 'package:flutter/material.dart';
import 'package:complex/widget/ItemTransaction.dart';
import 'package:animate_do/animate_do.dart';

class ListTransaction extends StatelessWidget {
  final Future<List<ItemTransaction>> list;

  ListTransaction({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: list,
      builder: (context, detalleSnap) {
        if (detalleSnap.hasData == false ||
            (detalleSnap.data.length == null || detalleSnap.data.length == 0)) {
          return Container();
        } else {
          return FadeIn(
            duration: Duration(milliseconds: 400),
            child: ListView.builder(
              itemCount: detalleSnap.data.length,
              itemBuilder: (context, index) {
                ItemTransaction detalle = detalleSnap.data[index];
                return detalle;
              },
            ),
          );
        }
      },
    );
  }
}

/*
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            if (item is ItemTransaction) {
              return ItemTransaction(item.header,item.body,item.footer);
            }
            
            return null;
          },
          ),
*/
