import 'package:complex/constant/Pages.dart';
import 'package:complex/constant/Utils.dart';
import 'package:complex/model/facade.dart';
import 'package:complex/model/model.dart';
import 'package:complex/widget/NotData.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class HorizontalListMetas extends StatelessWidget {
  final Future<List<Meta>> list;
  final ValueChanged<bool> refresh;

  HorizontalListMetas({this.list, this.refresh});

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
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: detalleSnap.data.length,
                itemBuilder: (context, index) {
                  Meta detalle = detalleSnap.data[index];
                  return FutureBuilder(
                    future: Facade.datosMeta(detalle),
                    builder: (context, dataMeta) {
                      if (dataMeta.connectionState == ConnectionState.waiting) {
                        return Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return InkWell(
                          child: ItemListMeta(
                            descripcion: detalle.descripcion,
                            depositado: dataMeta.data["depositado"],
                            diasFaltanes: dataMeta.data["diasFaltantes"],
                            fechaFin: detalle.fechaFin,
                            montoFinal: detalle.montoFinal,
                            porcentaje: dataMeta.data["porcentaje"],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MetasView(
                                  meta: detalle,
                                ),
                              ),
                            )
                                .then((value) => value ? refresh(value) : null)
                                .catchError((error) {
                              refresh(true);
                            });
                          },
                        );
                      }
                    },
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

class ItemListMeta extends StatelessWidget {
  final int porcentaje;
  final String descripcion;
  final String fechaFin;
  final int diasFaltanes;
  final double depositado;
  final double montoFinal;

  ItemListMeta({
    this.depositado,
    this.descripcion,
    this.diasFaltanes,
    this.fechaFin,
    this.montoFinal,
    this.porcentaje,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 12.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: 140,
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    descripcion,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Monto Final : ${UtilsFormat.formatNumber(montoFinal)} Gs.',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: <Widget>[
                        Text('${porcentaje}%',
                            style: Theme.of(context).textTheme.subtitle1),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.blue, width: 1),
                              shape: BoxShape.rectangle,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${UtilsFormat.formatNumber(depositado)} Gs.',
                                style: Theme.of(context).textTheme.subtitle1),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Fecha Meta : ${fechaFin}',
                      style: Theme.of(context).textTheme.subtitle1),
                  Text('Faltan ${diasFaltanes} días',
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            )
          ],
        ),
      ),
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
