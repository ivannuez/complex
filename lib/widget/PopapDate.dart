import 'package:complex/widget/Calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class PopapDate extends StatelessWidget {
  final DateTime date;
  final ValueChanged<String> onPress;

  PopapDate({this.date, this.onPress});

  Future<void> _getFecha(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black26,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Calendar(
            mes: DateFormat("MM", "es").format(date),
            onPress: onPress,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              toBeginningOfSentenceCase(DateFormat("MMMM", "es").format(date)),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.normal, color: Colors.white),
            ),
          ],
        ),
        onTap: () async {
          _getFecha(context);
        });
  }
}
