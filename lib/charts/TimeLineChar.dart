import 'package:flutter/material.dart';
import 'package:complex/widget/NotData.dart';
import 'package:complex/constant/Librerias.dart';
import 'package:complex/constant/Utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TimeLineChar extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> list;
  final bool animate;
  List<charts.Series<TimeSeries, DateTime>> seriesList;

  TimeLineChar(this.list, {this.animate});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: list,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: NotData(),
            );
          } else {
            List<TimeSeries> dataDB = new List<TimeSeries>();
            List<TimeSeries> newDataDB = new List<TimeSeries>();

            var bF;  
            for (Map<String, dynamic> d in snapshot.data) {
              bF = DateTime.parse(d["fecha"]);
              dataDB.add(new TimeSeries((new DateTime.utc(bF.year,bF.month,bF.day)),
                  UtilsFormat.doubleToInt(d["monto"])));
            }

            Map<DateTime, TimeSeries> mapa = new Map<DateTime, TimeSeries>();
            for (TimeSeries temp in dataDB) {
              mapa[temp.time] = temp;
            }

            var now = new DateTime.now();
            var inicio = new DateTime.utc(now.year, now.month, 1);
            var fin = new DateTime.utc(
                now.year, (now.month == 12 ? 1 : (now.month + 1)), 1);
            var difference = fin.difference(inicio);
            var differenceDays = difference.inDays;

            DateTime iDate;

            for (var i = 1; i <= differenceDays; i++) {
              iDate = (new DateTime.utc(now.year, now.month, i));
              if (mapa.containsKey(iDate)) {
                newDataDB.add(mapa[iDate]);
              } else {
                newDataDB.add((new TimeSeries((iDate), 0)));
              }
            }

            seriesList = [
              new charts.Series<TimeSeries, DateTime>(
                id: 'Sales',
                colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
                domainFn: (TimeSeries sales, _) => sales.time,
                measureFn: (TimeSeries sales, _) => sales.valor,
                measureLowerBoundFn: (TimeSeries sales, _) => sales.valor,
                measureUpperBoundFn: (TimeSeries sales, _) =>
                    sales.valor,
                data: newDataDB,
              )
            ];

            return FadeIn(
              duration: Duration(milliseconds: 400),
              child: new charts.TimeSeriesChart(
                seriesList,
                animate: animate,
                //defaultRenderer: new charts.BarRendererConfig<DateTime>(),
                /*flipVerticalAxis: false,
                defaultInteractions: false,*/
                dateTimeFactory: const charts.LocalDateTimeFactory(),
                //behaviors: [new charts.SelectNearest(), new charts.DomainHighlighter()],
              ),
            );
          }
        }
      },
    );
  }
}

class TimeSeries {
  final DateTime time;
  final int valor;

  TimeSeries(this.time, this.valor);
}
