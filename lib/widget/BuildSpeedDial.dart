import 'package:complex/pages/PrincipalForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class BuildSpeedDial extends StatelessWidget {
  const BuildSpeedDial({
    Key key,
    this.dialVisible,
    this.callback,
  }) : super(key: key);

  final bool dialVisible;
  final ValueChanged<bool> callback;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      overlayColor: Colors.white,
      overlayOpacity: 0.7,
      visible: dialVisible,
      curve: Curves.easeIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.arrow_downward, color: Colors.white),
          backgroundColor: Colors.red,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrincipalForm(
                  tipoForm: 'E',
                  textForm: 'Gasto',
                  editing: false,
                ),
              ),
            )
                .then((value) => value ? callback(value) : null)
                .catchError((error) {});
          },
          label: 'Egresos',
          labelStyle:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.red,
        ),
        SpeedDialChild(
          child: Icon(Icons.arrow_upward, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrincipalForm(
                  tipoForm: 'I',
                  textForm: 'Ingreso',
                  editing: false,
                ),
              ),
            )
                .then((value) => value ? callback(value) : null)
                .catchError((error) {});
          },
          label: 'Ingresos',
          labelStyle:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.green,
        ),
      ],
    );
  }
}
