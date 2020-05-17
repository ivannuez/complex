import 'package:complex/constant/Librerias.dart';
import 'package:complex/constant/Pages.dart';
import 'package:complex/constant/Utils.dart';
import 'package:complex/constant/Widget.dart';
import 'package:complex/model/model.dart';
import 'package:complex/model/facade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class MetasView extends StatefulWidget {
  Meta meta;

  MetasView({this.meta});

  @override
  _MetasViewState createState() => _MetasViewState();
}

class _MetasViewState extends State<MetasView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  DetallesMeta current = new DetallesMeta();

  @override
  void initState() {
    current.fecha = (new DateFormat("yyyy-MM-dd").format(new DateTime.now()));
    super.initState();
  }

  void refresh(bool refresh) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          'Detalle',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar',
            onPressed: () {
              goForm(editing: true, title: 'Meta', data: widget.meta);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Eliminar',
            onPressed: deleteBtMeta,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(15.0),
          child: ICircularBottom(
            height: 15,
            radius: 20,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, bottom: 65),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            header(),
            ultimosDepositos(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            viewModal(editing: false);
          }),
    );
  }

  Widget header() {
    return FutureBuilder<Map<String, dynamic>>(
      future: Facade.datosMeta(widget.meta),
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
            return FadeIn(
              duration: Duration(milliseconds: 400),
              child: Column(
                children: <Widget>[
                  Text(
                    widget.meta.descripcion,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Fecha Meta : ${widget.meta.fechaFin}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Container(
                    height: 190,
                    width: 190,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.symmetric(vertical: 7),
                    child: CustomPaint(
                      painter: CircularProgress(
                        porcentaje: snapshot.data["porcentaje"],
                        colorBase: Colors.blue[300],
                        colorArc: Colors.blue,
                        widthBase: 2.5,
                        widthArc: 10,
                      ),
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${snapshot.data["porcentaje"]}%',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${UtilsFormat.formatNumber(snapshot.data["depositado"])} Gs.',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 10),
                            Text('de : '),
                            Text(
                                '${UtilsFormat.formatNumber(widget.meta.montoFinal)} Gs.'),
                            SizedBox(height: 10),
                            Text('Quedan :'),
                            Text('${snapshot.data["diasFaltantes"]} días'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Debes de ahorrar por mes : ${UtilsFormat.formatNumber(snapshot.data["ahorrar"])} Gs.',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 5)
                ],
              ),
            );
          }
        }
      },
    );
  }

  Widget ultimosDepositos() {
    return Expanded(
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: double.infinity,
          //height: double.infinity,
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Últimos depositos",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Divider(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: ListTransactionMetas(
                    list: getDetalleMetas(widget.meta.idMeta),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void viewModal({bool editing}) {
    if (!editing) {
      current.metasIdMeta = widget.meta.idMeta;
    }
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
        side: BorderSide(color: Colors.blue),
      ),
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateModal) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Text(
                    'Nuevo Deposito',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title.copyWith(
                        color: Colors.blue, fontWeight: FontWeight.normal),
                  ),
                ),
                Divider(
                  height: 20,
                  color: Colors.blue,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2.9,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: FormBuilder(
                    key: _fbKey,
                    autovalidate: false,
                    child: Column(
                      children: <Widget>[
                        FormBuilderTextField(
                          attribute: "monto",
                          keyboardType: TextInputType.number,
                          inputFormatters: [NumericTextFormatter()],
                          initialValue: (current.monto > 0
                              ? UtilsFormat.formatNumber(current.monto)
                              : ''),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.attach_money),
                            labelText: 'Monto',
                          ),
                          validators: [
                            FormBuilderValidators.required(
                                errorText: 'Campo requerido.'),
                          ],
                          onChanged: (value) {
                            if (value != '') {
                              current.monto = double.parse(
                                  value.toString().replaceAll('.', ''));
                            }
                          },
                        ),
                        FormBuilderDateTimePicker(
                          attribute: "fecha",
                          inputType: InputType.date,
                          format: DateFormat("yyyy-MM-dd"),
                          initialValue: (current.fecha == null
                              ? DateTime.now()
                              : DateTime.parse(current.fecha)),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: 'Fecha',
                          ),
                          validators: [
                            FormBuilderValidators.required(
                                errorText: 'Campo requerido.'),
                          ],
                          onChanged: (value) {
                            current.fecha =
                                (new DateFormat("yyyy-MM-dd").format(value));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonBar(
                    alignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.blue,
                        onPressed: () {
                          current = new DetallesMeta();
                          current.fecha = (new DateFormat("yyyy-MM-dd")
                              .format(new DateTime.now()));
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar"),
                      ),
                      FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 30, right: 30),
                        splashColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.blue)),
                        onPressed: () {
                          confirmBt();
                        },
                        child: Text("Aceptar"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<List<DetallesMeta>> getDetalleMetas(int idMeta) async {
    return await DetallesMeta().select().metasIdMeta.equals(idMeta).toList();
  }

  void confirmBt() async {
    final form = _fbKey.currentState;
    if (form.validate()) {
      final res = await current.save();
      current = new DetallesMeta();
      current.fecha = (new DateFormat("yyyy-MM-dd").format(new DateTime.now()));
      setState(() {});
      Navigator.pop(context);
    } else {
      print('form is invalid');
    }
  }

  void goForm({bool editing, String title, Meta data}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MetasForm(
          editing: editing,
          textForm: title,
        ),
        settings: RouteSettings(
          arguments: data,
        ),
      ),
    ).then((value) => value ? refresh(true) : null).catchError((error) {});
  }

  void deleteBtMeta() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      tittle: '',
      desc: '¿Eliminar?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await widget.meta.delete();
        Navigator.of(context).pop(true);
      },
    ).show();
  }
}
