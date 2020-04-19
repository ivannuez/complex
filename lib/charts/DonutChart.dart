import 'package:flutter/material.dart';
import 'package:complex/widget/NotData.dart';
import 'package:complex/constant/Librerias.dart';
import 'package:complex/constant/Utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class DonutChart extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> list;
  final bool animate;
  List<charts.Series> seriesList;

  DonutChart(this.list, {this.animate});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
            List<DataChart> data = new List<DataChart>();
            int itemView = 5;
            int index = 1;
            int porcentaje = 0;
            int restoMonto = 0;
            int totalMonto = 0;

            for (Map<String, dynamic> d in detalleSnap.data) {
              totalMonto = totalMonto + d["monto"].toInt();
              if (index <= itemView) {
                index++;
                porcentaje = porcentaje + d["porcentaje"].toInt();
                restoMonto = restoMonto + d["monto"].toInt();
                DataChart item =
                    new DataChart(d["descripcion"], d["porcentaje"].toInt(), d["monto"].toInt(), d["color"].toInt());
                data.add(item);
              }
            }
            if(index > itemView){
              DataChart item =
                    new DataChart("Otros", (100 - porcentaje), (totalMonto - restoMonto ) ,Colors.grey.value);
                data.add(item);
            }

            seriesList = [
              new charts.Series<DataChart, String>(
                id: 'valor',
                domainFn: (DataChart valor, _) => valor.description,
                measureFn: (DataChart valor, _) => valor.monto,
                colorFn: (DataChart valor, _) => charts.Color.fromHex(code: '#'+ UtilsColor.convertColorValueToHex(valor.color)),
                data: data,
              )
            ];

            return FadeIn(
              duration: Duration(milliseconds: 400),
              child: new charts.PieChart(
                seriesList,
                animate: animate,
                layoutConfig: charts.LayoutConfig(
                  leftMarginSpec: charts.MarginSpec.fixedPixel(10),
                  topMarginSpec: charts.MarginSpec.fixedPixel(10),
                  rightMarginSpec: charts.MarginSpec.fixedPixel(0),
                  bottomMarginSpec: charts.MarginSpec.fixedPixel(10),
                ),
                behaviors: [
                  new charts.DatumLegend(
                    position: charts.BehaviorPosition.start,
                    horizontalFirst: false,
                    cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                    showMeasures: true,
                    insideJustification: charts.InsideJustification.topStart,
                    outsideJustification: charts.OutsideJustification.middle,
                    legendDefaultMeasure:
                        charts.LegendDefaultMeasure.average,
                    measureFormatter: (num value) {
                      return value == null ? '-' : 'Gs. '+ UtilsFormat.formatNumber(value);
                    },
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }
}

/// Sample linear data type.
class DataChart {
  final String description;
  final int porcentaje;
  final int monto;
  final int color;

  DataChart(this.description, this.porcentaje,this.monto, this.color);
}
