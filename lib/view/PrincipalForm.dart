import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:complex/providers/provider.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:complex/model/model.dart';
import 'package:complex/core/IHeader.dart';
import 'package:complex/core/IListTile.dart';

class PrincipalForm extends StatefulWidget {
  PrincipalForm({Key key, this.tipoForm, this.textForm}) : super(key: key);

  final String tipoForm;
  final String textForm;

  _PrincipalFormState createState() => _PrincipalFormState();
}

class _PrincipalFormState extends State<PrincipalForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  String fecha = (new DateFormat('y-MM-dd').format(DateTime.now())).toString();
  String descripcion = '';
  int monto = 0;
  Categoria selectedCategory;

  List<Categoria> categorias;

  @override
  void initState() {
    super.initState();
    getCategory().then((result) {
      setState(() {
        categorias = result;
      });
    });
  }

  Future<List<Categoria>> getCategory() async {
    return await Categoria().select().tipo.equals(widget.tipoForm).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor:
                (widget.tipoForm == 'I' ? Colors.green : Colors.red),
            title: Text('Nuevo ' + widget.textForm),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IHeader(
                text: 'Detalle',
                color: (widget.tipoForm == 'I' ? Colors.green : Colors.red),
              ),
              Flexible(
                flex: 1,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      FormBuilder(
                        key: _fbKey,
                        initialValue: {
                          'fecha': DateTime.now(),
                        },
                        autovalidate: true,
                        child: Column(
                          children: <Widget>[
                            FormBuilderTextField(
                              attribute: "Monto",
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.attach_money,
                                  color: Colors.green,
                                ),
                                hintText: 'Monto',
                              ),
                              validators: [
                                //FormBuilderValidators.numeric(),
                                //FormBuilderValidators.max(70),
                                //FormBuilderValidators.required(),
                                FormBuilderValidators.min(1)
                              ],
                              onChanged: (value) {
                                if (value != '') {
                                  monto = int.parse(value);
                                }
                              },
                              keyboardType: TextInputType.number,
                            ),
                            FormBuilderDateTimePicker(
                              attribute: "fecha",
                              inputType: InputType.date,
                              format: DateFormat("yyyy-MM-dd"),
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                ),
                                hintText: 'Fecha',
                              ),
                              validators: [
                                //FormBuilderValidators.required()
                              ],
                              onChanged: (value) {
                                fecha = value.toString();
                              },
                            ),
                            FormBuilderTextField(
                              attribute: "descripcion",
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.description,
                                  color: Colors.lime,
                                ),
                                hintText: 'Descripcion',
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              validators: [
                                //FormBuilderValidators.required()
                              ],
                              onChanged: (value) {
                                descripcion = value;
                              },
                              keyboardType: TextInputType.text,
                            ),
                            FormBuilderDropdown(
                              attribute: "categoria",
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.category,
                                  color: Colors.orange,
                                ),
                              ),
                              hint: Text('Categoria'),
                              validators: [
                                //FormBuilderValidators.required()
                              ],
                              onChanged: (catSelect) {
                                selectedCategory = catSelect;
                              },
                              items: categorias
                                  .map(
                                    (categoryItem) =>
                                        DropdownMenuItem<Categoria>(
                                      value: categoryItem,
                                      child: IListTile(
                                        color: Color(categoryItem.color),
                                        descripcion: categoryItem.descripcion,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 5.0,
            backgroundColor:
                (widget.tipoForm == 'I' ? Colors.green : Colors.red),
            onPressed: confirmBt,
            tooltip: 'Guardar',
            child: Icon(
              Icons.check,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat),
    );
  }

  void confirmBt() {
    final form = _fbKey.currentState;
    if (form.validate()) {
      print(selectedCategory.idCategoria);
      print(monto.toString());
      print(fecha);
      print(descripcion);
      var mainProvider = Provider.of<MainProvider>(context, listen: false);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        tittle: widget.textForm,
        desc: '¿Guardar?',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          final cuentaActual = await Cuenta()
              .select()
              .idCuenta
              .equals(
                  (mainProvider.cuentaId == null ? 1 : mainProvider.cuentaId))
              .toSingle();

          final result = await DetallesCuenta.withFields(
                  descripcion,
                  fecha,
                  monto.toDouble(),
                  (widget.tipoForm == 'I'
                      ? cuentaActual.saldo + monto
                      : cuentaActual.saldo - monto),
                  widget.tipoForm,
                  cuentaActual.idCuenta,
                  selectedCategory.idCategoria,
                  false)
              .save();

          if (result > 0) {
            if (widget.tipoForm == 'I') {
              var ingreso = (cuentaActual.totalIngreso == null
                      ? 0
                      : cuentaActual.totalIngreso) +
                  monto;
              var saldo =
                  (cuentaActual.saldo == null ? 0 : cuentaActual.saldo) + monto;
              mainProvider.updateIngreso(ingreso.toInt(), saldo.toInt());
              final sql = "UPDATE cuentas set totalIngreso = " +
                  ingreso.toString() +
                  ", saldo = " +
                  saldo.toString() +
                  " where idCuenta = " +
                  cuentaActual.idCuenta.toString();
              await DbComplex().execSQL(sql);
            } else {
              var egreso = (cuentaActual.totalEgreso == null
                      ? 0
                      : cuentaActual.totalEgreso) +
                  monto;
              var saldo =
                  (cuentaActual.saldo == null ? 0 : cuentaActual.saldo) - monto;
              mainProvider.updateEgreso(egreso.toInt(), saldo.toInt());

              final sql = "UPDATE cuentas set totalEgreso = " +
                  egreso.toString() +
                  ", saldo = " +
                  saldo.toString() +
                  " where idCuenta = " +
                  cuentaActual.idCuenta.toString();
              await DbComplex().execSQL(sql);
            }
          } else {
            print('no guardado');
          }
          Navigator.pop(context);
        },
      ).show();
    } else {
      print('form is invalid');
    }
  }
}
