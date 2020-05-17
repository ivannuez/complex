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
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.connectionState != ConnectionState.done) {
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
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Gs. " + UtilsFormat.formatNumber(snapshot.data["saldo"]),
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Text(
                      'Ingresos:',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.white),
                    ),
                    Spacer(),
                    Text(
                      "Gs. " +
                          UtilsFormat.formatNumber(snapshot.data["ingresos"]),
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Text(
                      'Egresos:',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.white),
                    ),
                    Spacer(),
                    Text(
                      "Gs. " +
                          UtilsFormat.formatNumber(snapshot.data["egresos"]),
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
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
