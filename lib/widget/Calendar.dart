import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  final ValueChanged<String> onPress;
  final String mes;

  Calendar({this.mes,this.onPress});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String year;
  String month;

  @override
  void initState() {
    super.initState();
    year = (new DateFormat("yyyy").format(new DateTime.now()));
    month = (new DateFormat("MM").format(new DateTime.now()));
  }

  void addYear() {
    setState(() {
      year = (int.parse(year) + 1).toString();
    });
  }

  void subtractYear() {
    setState(() {
      year = (int.parse(year) - 1).toString();
    });
  }

  void cancelar() {
    widget.onPress("");
    Navigator.pop(context);
  }

  void mesActual() {
    year = (new DateFormat("yyyy").format(new DateTime.now()));
    month = (new DateFormat("MM").format(new DateTime.now()));
    widget.onPress(year+"-"+month);
    Navigator.pop(context);
  }

  void selectMonth(String mes) {
    widget.onPress(year+"-"+mes);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
      elevation: 5.0,
      child: Container(
        height: 210.0,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              height: 50,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    color: Colors.white,
                    onPressed: subtractYear,
                  ),
                  Text(
                    year,
                    style: Theme.of(context).textTheme.title.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).primaryTextTheme.body1.color),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    color: Colors.white,
                    onPressed: addYear,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
                alignment: Alignment.center,
                child: Table(
                  children: [
                    TableRow(children: [
                      FlatButton(
                        child: Text('Ene.',style: TextStyle(fontSize: 13,color: (widget.mes == '01' ? Colors.blue : Colors.black)),),
                        onPressed: (){
                          selectMonth("01");
                        },
                      ),
                      FlatButton(
                        child: Text('Feb.',style: TextStyle(fontSize: 13,color: (widget.mes == '02' ? Colors.blue : Colors.black)),),
                        onPressed: (){
                          selectMonth("02");
                        },
                      ),
                      FlatButton(
                        child: Text('Mar.',style: TextStyle(fontSize: 13,color: (widget.mes == '03' ? Colors.blue : Colors.black)),),
                        onPressed: (){
                          selectMonth("03");
                        },
                      ),
                      FlatButton(
                        child: Text('Abr.',style: TextStyle(fontSize: 13,color: (widget.mes == '04' ? Colors.blue : Colors.black)),),
                        onPressed: (){
                          selectMonth("04");
                        },
                      ),
                      FlatButton(
                        child: Text('May.',style: TextStyle(fontSize: 13,color: (widget.mes == '05' ? Colors.blue : Colors.black)),),
                        onPressed: (){
                          selectMonth("05");
                        },
                      ),
                      FlatButton(
                        child: Text('Jun.',style: TextStyle(fontSize: 13,color: (widget.mes == '06' ? Colors.blue : Colors.black)),),
                        onPressed: (){
                          selectMonth("06");
                        },
                      ),
                    ]),
                    TableRow(children: [
                      FlatButton(
                        child: Text('Jul.',style: TextStyle(fontSize: 13,color: (widget.mes == '07' ? Colors.blue : Colors.black)),),
                        onPressed: (){
                          selectMonth("07");
                        },
                      ),
                      FlatButton(
                        child: Text('Ago.',style: TextStyle(fontSize: 13,color: (widget.mes == '08' ? Colors.blue : Colors.black)),),
                        onPressed: (){
                          selectMonth("08");
                        },
                      ),
                      FlatButton(
                        child: Text('Sep.',style: TextStyle(fontSize: 13,color: (widget.mes == '09' ? Colors.blue : Colors.black)),),
                        onPressed: (){
                          selectMonth("09");
                        },
                      ),
                      FlatButton(
                        child: Text('Oct.',style: TextStyle(fontSize: 13,color: (widget.mes == '10' ? Colors.blue : Colors.black)),),
                        onPressed: (){
                          selectMonth("10");
                        },
                      ),
                      FlatButton(
                        child: Text('Nov.',style: TextStyle(fontSize: 13,color: (widget.mes == '11' ? Colors.blue : Colors.black)),),
                        onPressed: (){
                          selectMonth("11");
                        },
                      ),
                      FlatButton(
                        child: Text('Dic.',style: TextStyle(fontSize: 13,color: (widget.mes == '12' ? Colors.blue : Colors.black)),),
                        onPressed: (){
                          selectMonth("12");
                        },
                      ),
                    ])
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: cancelar,
                ),
                FlatButton(
                  child: Text(
                    'Mes Actual',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: mesActual,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
