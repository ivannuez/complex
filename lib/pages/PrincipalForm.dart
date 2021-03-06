import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:complex/constant/Widget.dart';
import 'package:complex/constant/Librerias.dart';
import 'package:complex/constant/Utils.dart';
import 'package:complex/providers/provider.dart';
import 'package:complex/model/model.dart';
import 'package:complex/model/facade.dart';

class PrincipalForm extends StatefulWidget {
  PrincipalForm({Key key, this.tipoForm, this.textForm, this.editing})
      : super(key: key);

  final String tipoForm;
  final String textForm;
  final bool editing;

  _PrincipalFormState createState() => _PrincipalFormState();
}

class _PrincipalFormState extends State<PrincipalForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  DetallesCuenta current = new DetallesCuenta();
  bool loading = true;
  Categoria selectedCategory;
  List<Categoria> categorias;
  double montoAnterior = 0;

  bool procesando = false;

  String returnPage = '';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es', null);
    current.fecha = (new DateFormat("yyyy-MM-dd").format(new DateTime.now()));
    Facade.getCategory(widget.tipoForm).then((result) {
      setState(() {
        categorias = result;
        loading = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setData(DetallesCuenta selected) {
    current = selected;
    montoAnterior = current.monto;
    selected.getCategoria().then((value) {
      setState(() {
        selectedCategory = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    DetallesCuenta transaction = ModalRoute.of(context).settings.arguments;
    if (transaction != null && current.idDetalleCuenta == null) {
      setData(transaction);
    }

    return Container(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            backgroundColor:
                (widget.tipoForm == 'I' ? Colors.green : Colors.red),
            title: Text(
              (!widget.editing ? 'Nuevo ' : 'Editar ') + widget.textForm,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.white),
            ),
            actions: <Widget>[
              (widget.editing == true
                  ? IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Borrar',
                      onPressed: deleteBt,
                    )
                  : Container()),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(15.0),
              child: ICircularBottom(
                height: 15,
                radius: 20,
              ),
            ),
          ),
          body: (!loading
              ? Container()
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      FormBuilder(
                        key: _fbKey,
                        autovalidate: false,
                        child: Column(
                          children: <Widget>[
                            FormBuilderTextField(
                              autofocus: (!widget.editing ? true : false),
                              attribute: "monto",
                              keyboardType: TextInputType.number,
                              inputFormatters: [NumericTextFormatter()],
                              initialValue: (current.monto > 0
                                  ? UtilsFormat.formatNumber(current.monto)
                                  : ''),
                              decoration: const InputDecoration(
                                labelText: "Monto",
                                icon: Icon(Icons.attach_money),
                                //hintText: 'Monto',
                              ),
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: 'Campo requerido.')
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
                                labelText: "Fecha",
                                //hintText: 'Fecha',
                              ),
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: 'Campo requerido.'),
                              ],
                              onChanged: (value) {
                                current.fecha = (new DateFormat("yyyy-MM-dd")
                                    .format(value));
                              },
                            ),
                            FormBuilderTextField(
                              keyboardType: TextInputType.text,
                              initialValue: current.descripcion,
                              attribute: "descripcion",
                              decoration: const InputDecoration(
                                icon: Icon(Icons.description),
                                labelText: "Descripcion",
                                //hintText: 'Descripcion',
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: 'Campo requerido.'),
                              ],
                              onChanged: (value) {
                                current.descripcion = value;
                              },
                            ),
                            FormBuilderDropdown(
                              isDense: false,
                              initialValue: selectedCategory,
                              attribute: "categoria",
                              decoration: const InputDecoration(
                                icon: Icon(Icons.category),
                                labelText: "Categoria",
                              ),
                              hint: (selectedCategory == null
                                  ? Text('Seleccione un Categoria')
                                  : IListTile(
                                      color: MaterialColor(
                                          selectedCategory.color, null),
                                      descripcion: selectedCategory.descripcion,
                                    )),
                              validators: (!widget.editing
                                  ? [
                                      FormBuilderValidators.required(
                                          errorText: 'Campo requerido.')
                                    ]
                                  : []),
                              onChanged: (catSelect) {
                                selectedCategory = catSelect;
                              },
                              items: categorias == null
                                  ? []
                                  : categorias
                                      .map(
                                        (categoryItem) =>
                                            DropdownMenuItem<Categoria>(
                                          value: categoryItem,
                                          child: IListTile(
                                            color: MaterialColor(
                                                categoryItem.color, null),
                                            descripcion:
                                                categoryItem.descripcion,
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
                )),
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
    String field = '';
    String action = '';
    double saldo = 0;
    double campo = 0;
    double monto = 0;
    double montoNuevo = 0;

    if (form.validate()) {
      var mainProvider = Provider.of<MainProvider>(context, listen: false);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        body: (!procesando ? Text('¿Guardar?') : CircularProgressIndicator()),
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          setState(() {
            procesando = true;
          });
          final cuentaActual = await Cuenta()
              .select()
              .idCuenta
              .equals(mainProvider.cuentaId)
              .toSingle();

          current.tipoTransaccion = widget.tipoForm;
          current.cuentasIdCuenta = cuentaActual.idCuenta;
          current.categoriasIdCategoria = selectedCategory.idCategoria;

          final result = await current.save();

          if (result > 0) {
            if (widget.editing) {
              monto = current.monto;
              saldo = cuentaActual.saldo;
              if (monto == montoAnterior) {
                montoNuevo = 0;
              } else if (montoAnterior > monto) {
                montoNuevo = montoAnterior - monto;
                saldo = saldo - montoNuevo;
                action = 'restar';
              } else {
                montoNuevo = monto - montoAnterior;
                saldo = saldo + montoNuevo;
                action = 'sumar';
              }
              if (widget.tipoForm == 'I') {
                field = 'totalIngreso';
                if (action == 'sumar') {
                  campo = cuentaActual.totalIngreso + montoNuevo;
                } else {
                  campo = cuentaActual.totalIngreso - montoNuevo;
                }
              } else {
                field = 'totalEgreso';
                if (action == 'sumar') {
                  campo = cuentaActual.totalEgreso + montoNuevo;
                } else {
                  campo = cuentaActual.totalEgreso - montoNuevo;
                }
              }
            } else {
              if (widget.tipoForm == 'I') {
                field = 'totalIngreso';
                campo = (cuentaActual.totalIngreso == null
                        ? 0
                        : cuentaActual.totalIngreso) +
                    current.monto;
                saldo = (cuentaActual.saldo == null ? 0 : cuentaActual.saldo) +
                    current.monto;
              } else {
                field = 'totalEgreso';
                campo = (cuentaActual.totalEgreso == null
                        ? 0
                        : cuentaActual.totalEgreso) +
                    current.monto;
                saldo = (cuentaActual.saldo == null ? 0 : cuentaActual.saldo) -
                    current.monto;
              }
            }
            final sql =
                "UPDATE cuentas set ${field} = ${campo}, saldo = ${saldo} where idCuenta = ${cuentaActual.idCuenta}";
            await DbComplex().execSQL(sql);

            // Actualizamos la tabla de Saldos
            if (widget.editing) {
              double nuevoSaldo = 0;
              final ultimoSaldo = await Saldo()
                  .select()
                  .fecha
                  .startsWith(current.fecha.substring(0, 7))
                  .orderByDesc("idSaldo")
                  .toSingle();
              if (action == 'sumar') {
                nuevoSaldo = ultimoSaldo.monto + montoNuevo;
                ultimoSaldo.monto = nuevoSaldo;
                ultimoSaldo.save();
              } else {
                nuevoSaldo = ultimoSaldo.monto - montoNuevo;
                ultimoSaldo.monto = nuevoSaldo;
                ultimoSaldo.save();
              }
            } else {
              await Saldo(
                      cuentasIdCuenta: cuentaActual.idCuenta,
                      fecha: current.fecha,
                      monto: saldo)
                  .save();
            }
          } else {
            print('no guardado');
          }
          Navigator.of(context).pop(true);
          /*
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/base',
            (Route<dynamic> route) => false,
          );
          */
        },
      ).show();
    } else {
      print('form is invalid');
    }
  }

  void deleteBt() {
    var mainProvider = Provider.of<MainProvider>(context, listen: false);
    String field = '';
    double saldo = 0;
    double campo = 0;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      tittle: widget.textForm,
      desc: '¿Eliminar?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        final cuentaActual = await Cuenta()
            .select()
            .idCuenta
            .equals(mainProvider.cuentaId)
            .toSingle();

        final result = await current.delete(true);

        if (result.success) {
          if (widget.tipoForm == 'I') {
            field = 'totalIngreso';
            campo = cuentaActual.totalIngreso - current.monto;
            saldo = campo - cuentaActual.totalEgreso;
          } else {
            field = 'totalEgreso';
            campo = cuentaActual.totalEgreso - current.monto;
            saldo = cuentaActual.totalIngreso - campo;
          }
          final sql =
              "UPDATE cuentas set ${field} = ${campo}, saldo = ${saldo} where idCuenta = ${cuentaActual.idCuenta}";
          await DbComplex().execSQL(sql);

          //Actualizamos la tabla de Saldos
          double nuevoSaldo = 0;
          final ultimoSaldo = await Saldo()
              .select()
              .fecha
              .startsWith(current.fecha.substring(0, 7))
              .orderBy("fecha")
              .toSingle();

          if (widget.tipoForm == 'I') {
            nuevoSaldo = ultimoSaldo.monto - current.monto;
            ultimoSaldo.monto = nuevoSaldo;
            ultimoSaldo.save();
          } else {
            nuevoSaldo = ultimoSaldo.monto + current.monto;
            ultimoSaldo.monto = nuevoSaldo;
            ultimoSaldo.save();
          }
        } else {
          print('no se pudo borrar : ${result.errorMessage}');
        }
        Navigator.of(context).pop(true);
      },
    ).show();
  }
}
