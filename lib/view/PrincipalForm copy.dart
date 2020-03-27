import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:complex/providers/provider.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:complex/model/model.dart';

class PrincipalForm extends StatefulWidget {
  PrincipalForm({Key key, this.tipoForm, this.textForm}) : super(key: key);

  final String tipoForm;
  final String textForm;

  _PrincipalFormState createState() => _PrincipalFormState();
}

class _PrincipalFormState extends State<PrincipalForm> {
  final _formKey = new GlobalKey<FormState>();

  String fecha = '';
  String descripcion = '';
  int monto;

  Categoria selectedCategory;
  List<Categoria> categorias;

  Future<List<Categoria>> getCategory() async {
    //print('obteniendo datos..');
    return await Categoria().select().tipo.equals(widget.tipoForm).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor:
                (widget.tipoForm == 'I' ? Colors.green : Colors.red),
            title: Text('Nuevo ' + widget.textForm),
          ),
          body: Stack(
            children: <Widget>[
              Container(
                color: (widget.tipoForm == 'I' ? Colors.green : Colors.red),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      color:
                          (widget.tipoForm == 'I' ? Colors.green : Colors.red),
                      padding: EdgeInsets.all(20.0),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Detalle',
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
                        width: double.infinity,
                        height: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty ||
                                            int.parse(value) <= 0) {
                                          return 'Ingrese un monto mayor a 0';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.attach_money,
                                          color: Colors.green,
                                        ),
                                        hintText: 'Monto',
                                      ),
                                      maxLines: 1,
                                      onChanged: (texto) {
                                        monto = int.parse(texto);
                                      },
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      //inputFormatters: [maskFormatter],
                                    ),
                                    InputDecorator(
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.calendar_today,
                                          color: Colors.blue,
                                        ),
                                        hintText: 'Fecha',
                                      ),
                                      isEmpty: fecha == '',
                                      child: GestureDetector(
                                        onTap: () async {
                                          DateTime picked =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2018),
                                            lastDate: DateTime(2030),
                                          );
                                          if (picked != null) {
                                            setState(() {
                                              fecha = (new DateFormat('y-MM-dd')
                                                      .format(picked))
                                                  .toString();
                                            });
                                          }
                                        },
                                        child: Text(fecha),
                                      ),
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.description,
                                          color: Colors.lime,
                                        ),
                                        hintText: 'Descripcion',
                                      ),
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      maxLines: 1,
                                      onChanged: (texto) {
                                        descripcion = texto;
                                      },
                                    ),
                                    InputDecorator(
                                      decoration: const InputDecoration(
                                        icon: Icon(
                                          Icons.category,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: FutureBuilder<List<Categoria>>(
                                          future: getCategory(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState !=
                                                    ConnectionState.done ||
                                                snapshot.data == null) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              List<DropdownMenuItem<Categoria>>
                                                  listCategory = new List<
                                                      DropdownMenuItem<
                                                          Categoria>>();
                                              snapshot.data.forEach(
                                                (categoryItem) {
                                                  listCategory.add(
                                                    DropdownMenuItem<Categoria>(
                                                      value: categoryItem,
                                                      child: Row(
                                                        children: <Widget>[
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Color(
                                                                    categoryItem
                                                                        .color),
                                                            child: Text(
                                                              categoryItem
                                                                  .descripcion[0],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Text(
                                                            categoryItem
                                                                .descripcion,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                              return DropdownButton(
                                                items: listCategory,
                                                onChanged:
                                                    (Categoria selected) {
                                                  setState(() {
                                                    selectedCategory = selected;
                                                  });
                                                },
                                                hint: (selectedCategory == null
                                                    ? Text("Categoria")
                                                    : Row(
                                                        children: <Widget>[
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Color(
                                                                    selectedCategory
                                                                        .color),
                                                            child: Text(
                                                              selectedCategory
                                                                  .descripcion[0],
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Text(
                                                            selectedCategory
                                                                .descripcion,
                                                          ),
                                                        ],
                                                      ),),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.green,
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
    final form = _formKey.currentState;
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
              .equals(
                  (mainProvider.cuentaId == null ? 1 : mainProvider.cuentaId))
              .toSingle();

          final result = await DetallesCuenta.withFields(
                  descripcion,
                  fecha,
                  monto.toDouble(),
                  (widget.tipoForm == 'I' ? cuentaActual.saldo + monto : cuentaActual.saldo - monto),
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
