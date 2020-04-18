import 'package:complex/core/IListTile.dart';
import 'package:complex/utils/UtilsFormat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:complex/providers/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:complex/model/model.dart';
import 'package:complex/core/IHeader.dart';
import 'package:complex/utils/NumericTextFormatter.dart';

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

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es', null);
    current.fecha = (new DateFormat("yyyy-MM-dd").format(new DateTime.now()));
    getCategory().then((result) {
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

  void setData(DetallesCuenta detallesCuenta) {
    current = detallesCuenta;
    montoAnterior = current.monto;
    detallesCuenta.getCategoria().then((value) {
      setState(() {
        selectedCategory = value;
      });
    });
  }

  Future<List<Categoria>> getCategory() async {
    return await Categoria().select().tipo.equals(widget.tipoForm).toList();
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
            backgroundColor:
                (widget.tipoForm == 'I' ? Colors.green : Colors.red),
            title: Text(
                (!widget.editing ? 'Nuevo ' : 'Editar ') + widget.textForm),
            actions: <Widget>[
              (widget.editing == true
                  ? IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Borrar',
                      onPressed: deleteBt,
                    )
                  : Container()),
            ],
          ),
          body: (!loading
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IHeader(
                      text: 'Detalle',
                      color:
                          (widget.tipoForm == 'I' ? Colors.green : Colors.red),
                    ),
                    Flexible(
                      flex: 1,
                      child: SingleChildScrollView(
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
                                        ? UtilsFormat.formatNumber(
                                            current.monto)
                                        : ''),
                                    decoration: const InputDecoration(
                                      icon: Icon(
                                        Icons.attach_money,
                                        color: Colors.green,
                                      ),
                                      hintText: 'Monto',
                                    ),
                                    validators: [
                                      FormBuilderValidators.required(
                                          errorText: 'Campo requerido.'),
                                    ],
                                    onChanged: (value) {
                                      if (value != '') {
                                        current.monto = double.parse(value
                                            .toString()
                                            .replaceAll('.', ''));
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
                                      icon: Icon(
                                        Icons.calendar_today,
                                        color: Colors.blue,
                                      ),
                                      hintText: 'Fecha',
                                    ),
                                    validators: [
                                      FormBuilderValidators.required(
                                          errorText: 'Campo requerido.'),
                                    ],
                                    onChanged: (value) {
                                      current.fecha =
                                          (new DateFormat("yyyy-MM-dd")
                                              .format(value));
                                    },
                                  ),
                                  FormBuilderTextField(
                                    keyboardType: TextInputType.text,
                                    initialValue: current.descripcion,
                                    attribute: "descripcion",
                                    decoration: const InputDecoration(
                                      icon: Icon(
                                        Icons.description,
                                        color: Colors.lime,
                                      ),
                                      hintText: 'Descripcion',
                                    ),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    validators: [
                                      FormBuilderValidators.required(
                                          errorText: 'Campo requerido.'),
                                    ],
                                    onChanged: (value) {
                                      current.descripcion = value;
                                    },
                                  ),
                                  FormBuilderDropdown(
                                    initialValue: selectedCategory,
                                    attribute: "categoria",
                                    decoration: const InputDecoration(
                                      icon: Icon(
                                        Icons.category,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    hint: (selectedCategory == null
                                        ? Text('Categoria')
                                        : IListTile(
                                            color:
                                                Color(selectedCategory.color),
                                            descripcion:
                                                selectedCategory.descripcion,
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
                                                  color:
                                                      Color(categoryItem.color),
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
                      ),
                    )
                  ],
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
        tittle: widget.textForm,
        desc: '¿Guardar?',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
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
                mainProvider.updateIngreso(campo.toInt(), saldo.toInt());
              } else {
                field = 'totalEgreso';
                if (action == 'sumar') {
                  campo = cuentaActual.totalEgreso + montoNuevo;
                } else {
                  campo = cuentaActual.totalEgreso - montoNuevo;
                }
                mainProvider.updateEgreso(campo.toInt(), saldo.toInt());
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
                mainProvider.updateIngreso(campo.toInt(), saldo.toInt());
              } else {
                field = 'totalEgreso';
                campo = (cuentaActual.totalEgreso == null
                        ? 0
                        : cuentaActual.totalEgreso) +
                    current.monto;
                saldo = (cuentaActual.saldo == null ? 0 : cuentaActual.saldo) -
                    current.monto;
                mainProvider.updateEgreso(campo.toInt(), saldo.toInt());
              }
            }
            final sql =
                "UPDATE cuentas set ${field} = ${campo}, saldo = ${saldo} where idCuenta = ${cuentaActual.idCuenta}";
            await DbComplex().execSQL(sql);
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
            mainProvider.updateIngreso(campo.toInt(), saldo.toInt());
          } else {
            field = 'totalEgreso';
            campo = cuentaActual.totalEgreso - current.monto;
            saldo = cuentaActual.totalIngreso - campo;
            mainProvider.updateEgreso(campo.toInt(), saldo.toInt());
          }
          final sql =
              "UPDATE cuentas set ${field} = ${campo}, saldo = ${saldo} where idCuenta = ${cuentaActual.idCuenta}";
          await DbComplex().execSQL(sql);
        } else {
          print('no se pudo borrar : ${result.errorMessage}');
        }
        Navigator.pop(context);
      },
    ).show();
  }
}
