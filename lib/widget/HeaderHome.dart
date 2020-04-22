import 'package:flutter/material.dart';
import 'package:complex/constant/Utils.dart';

class HeaderHome extends StatelessWidget {
  final Future<Map<String, int>> list;

  HeaderHome({this.list});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: list,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Saldo:',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Gs. " + UtilsFormat.formatNumber(snapshot.data["saldo"]),
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Ingresos:',
                      style: Theme.of(context).textTheme.title,
                    ),
                    Spacer(),
                    Text(
                      "Gs. " +
                          UtilsFormat.formatNumber(snapshot.data["ingresos"]),
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Egresos:',
                      style: Theme.of(context).textTheme.title,
                    ),
                    Spacer(),
                    Text(
                      "Gs. " +
                          UtilsFormat.formatNumber(snapshot.data["egresos"]),
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
