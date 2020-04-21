import 'package:complex/widget/NotData.dart';
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
                  ItemTransaction detalle = detalleSnap.data[index];
                  return detalle;
                },
              ),
            );
          }
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
