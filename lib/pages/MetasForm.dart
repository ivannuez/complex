import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:complex/constant/Widget.dart';
import 'package:complex/constant/Librerias.dart';
import 'package:complex/constant/Utils.dart';
import 'package:complex/model/model.dart';

class MetasForm extends StatefulWidget {
  MetasForm({Key key, this.textForm, this.editing}) : super(key: key);

  final String textForm;
  final bool editing;

  _MetasFormState createState() => _MetasFormState();
}

class _MetasFormState extends State<MetasForm> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Meta current = new Meta();
  bool loading = true;

  bool procesando = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es', null);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setData(Meta selected) {
    current = selected;
  }

  @override
  Widget build(BuildContext context) {
    Meta dataRoute = ModalRoute.of(context).settings.arguments;
    if (dataRoute != null && current.idMeta == null) {
      setData(dataRoute);
    }

    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          title: Text(
            (!widget.editing ? 'Nueva ' : 'Editar ') + widget.textForm,
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
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _fbKey,
                autovalidate: false,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      keyboardType: TextInputType.text,
                      initialValue: current.descripcion,
                      attribute: "descripcion",
                      decoration: const InputDecoration(
                        icon: Icon(Icons.description),
                        labelText: 'Nombre',
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
                    FormBuilderTextField(
                      attribute: "monto",
                      keyboardType: TextInputType.number,
                      inputFormatters: [NumericTextFormatter()],
                      initialValue: (current.montoFinal > 0
                          ? UtilsFormat.formatNumber(current.montoFinal)
                          : ''),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.attach_money),
                        labelText: 'Monto de la Meta',
                      ),
                      validators: [
                        FormBuilderValidators.required(
                            errorText: 'Campo requerido.'),
                      ],
                      onChanged: (value) {
                        if (value != '') {
                          current.montoFinal = double.parse(
                              value.toString().replaceAll('.', ''));
                        }
                      },
                    ),
                    FormBuilderDateTimePicker(
                      attribute: "fecha",
                      inputType: InputType.date,
                      format: DateFormat("yyyy-MM-dd"),
                      initialValue: (current.fechaFin == null
                          ? null
                          : DateTime.parse(current.fechaFin)),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: 'Fecha Final',
                      ),
                      validators: [
                        FormBuilderValidators.required(
                            errorText: 'Campo requerido.'),
                      ],
                      onChanged: (value) {
                        current.fechaFin =
                            (new DateFormat("yyyy-MM-dd").format(value));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 5.0,
          onPressed: confirmBt,
          tooltip: 'Guardar',
          child: Icon(
            Icons.check,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  void confirmBt() {
    final form = _fbKey.currentState;
    if (form.validate()) {
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

          await current.save();

          Navigator.pop(context, true);
        },
      ).show();
    } else {
      print('form is invalid');
    }
  }

  void deleteBt() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      tittle: '',
      desc: '¿Eliminar?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await current.delete(true);

        Navigator.of(context).pushNamedAndRemoveUntil(
          '/base',
          (Route<dynamic> route) => false,
        );
      },
    ).show();
  }
}
