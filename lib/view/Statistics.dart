import 'package:flutter/material.dart';
import 'package:complex/core/ICircularBottom.dart';

class Statistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Estadisticas'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(15.0),
          child: ICircularBottom(
            height: 15,
            radius: 20,
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text('Proximamente...'),
            )
          ],
        ),
      ),
    );
  }
}
