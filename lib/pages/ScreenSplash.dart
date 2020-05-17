import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "dart:async";
import 'package:splashscreen/splashscreen.dart';
import 'package:complex/model/model.dart';
import 'package:complex/providers/provider.dart';
import 'package:complex/constant/Pages.dart';

class ScreenSplash extends StatefulWidget {
  @override
  _ScreenSplashState createState() => new _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  void initState() {
    super.initState();
    scheduleMicrotask(
      () async => {await getDataInit()},
    );
  }

  getDataInit() async {
    try {
      var mainProvider = Provider.of<MainProvider>(context, listen: false);

      final usuarios = await Usuario().select().toList();
      if (usuarios.length <= 0) {
        final usuario = await Usuario.withFields("Default").save();
        final cuenta =
            await Cuenta.withFields("Personal", 0, 0, 0, usuario).save();
        mainProvider.initialState("Default", usuario, cuenta, 0, 0, 0);

        /*Creando Categorias por defecto*/
        //print('Creando Categorias...');
        await Categoria(
                descripcion: 'Salario', color: Colors.green.value, tipo: 'I')
            .save();
        await Categoria(
                descripcion: 'Aguinaldo', color: Colors.lime.value, tipo: 'I')
            .save();
        await Categoria(
                descripcion: 'Inversiones',
                color: Colors.limeAccent.value,
                tipo: 'I')
            .save();
        await Categoria(
                descripcion: 'Premio',
                color: Colors.lightGreen.value,
                tipo: 'I')
            .save();
        await Categoria(
                descripcion: 'Regalo',
                color: Colors.lightGreenAccent.value,
                tipo: 'I')
            .save();
        await Categoria(
                descripcion: 'Bono', color: Colors.teal.value, tipo: 'I')
            .save();
        await Categoria(
                descripcion: 'Otros Ingresos',
                color: Colors.greenAccent.value,
                tipo: 'I')
            .save();

        await Categoria(
                descripcion: 'Alimentación',
                color: Colors.blue.value,
                tipo: 'E')
            .save();
        await Categoria(
                descripcion: 'Combustible',
                color: Colors.purple.value,
                tipo: 'E')
            .save();
        await Categoria(descripcion: 'Deudas', color: 4294198070, tipo: 'E')
            .save();
        await Categoria(descripcion: 'Diezmo', color: 4290406600, tipo: 'E')
            .save();
        await Categoria(
                descripcion: 'Ofrenda', color: Colors.yellow.value, tipo: 'E')
            .save();
        await Categoria(descripcion: 'Ahorros', color: 4290190364, tipo: 'E')
            .save();
        await Categoria(
                descripcion: 'Entretenimiento', color: 4278278043, tipo: 'E')
            .save();
        await Categoria(descripcion: 'Educación', color: 4281559326, tipo: 'E')
            .save();
        await Categoria(descripcion: 'Facturas', color: 4294278144, tipo: 'E')
            .save();
        await Categoria(
                descripcion: 'Gastos Personales', color: 4294826037, tipo: 'E')
            .save();
        await Categoria(
                descripcion: 'Gastos Varios', color: 4293467747, tipo: 'E')
            .save();
        await Categoria(descripcion: 'Casa', color: 4294945600, tipo: 'E')
            .save();
        await Categoria(descripcion: 'Perdida', color: 4294907716, tipo: 'E')
            .save();
        await Categoria(descripcion: 'Vestimenta', color: 4284955319, tipo: 'E')
            .save();
        await Categoria(
                descripcion: 'Salud',
                color: Colors.lightBlueAccent.value,
                tipo: 'E')
            .save();
      } else {
        final cuentas = await Cuenta().select().toList();
        mainProvider.initialState(
          usuarios[0].nombre,
          usuarios[0].idUsuario,
          cuentas[0].idCuenta,
          cuentas[0].totalIngreso.toInt(),
          cuentas[0].totalEgreso.toInt(),
          cuentas[0].saldo.toInt(),
        );
      }
    } catch (e) {
      print('ERROR : ');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 1,
      navigateAfterSeconds: Base(),
      image: new Image.asset('assets/images/icono-app.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.blue,
    );
  }
}
