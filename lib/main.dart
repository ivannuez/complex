import "dart:async";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:complex/providers/provider.dart';
import 'package:complex/view/MyHomePage.dart';
import 'package:complex/view/PrincipalForm.dart';
import 'package:complex/view/TransactionList.dart';
import 'package:complex/view/Settings.dart';
import 'package:complex/view/CategoryView.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:complex/model/model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Control Cash',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => ScreenSplash(),
          '/home': (context) => MyHomePage(),
          '/transtionList': (context) => TransactionList(
                tipoForm: 'T',
                textForm: 'Transacciones',
              ),
          '/principalForm': (context) => PrincipalForm(),
          '/settings': (context) => Settings(),
          '/settings/category': (context) => CategoryView(),
        },
      ),
    );
  }
}

class ScreenSplash extends StatefulWidget {
  @override
  _ScreenSplashState createState() => new _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  void initState() {
    super.initState();
    scheduleMicrotask(
      () async => {
        await getDataInit()
      },
    );
  }

   getDataInit() async {
    try {
      var mainProvider = Provider.of<MainProvider>(context, listen: false);
      final usuarios = await Usuario().select().toList();
      if (usuarios.length <= 0) {
        final usuario = await Usuario.withFields("Default", false).save();
        final cuenta =
            await Cuenta.withFields("Personal", 0, 0, 0, usuario, false).save();
        mainProvider.initialState("Default", usuario, cuenta, 0, 0, 0);

        /*Creando Categorias por defecto*/
        //print('Creando Categorias...');
        await Categoria(descripcion: 'Salario', color: Colors.green.value,  tipo: 'I').save();
        await Categoria(descripcion: 'Aguinaldo', color: Colors.lime.value,  tipo: 'I').save();
        await Categoria(descripcion: 'Inversiones', color: Colors.limeAccent.value,  tipo: 'I').save();
        await Categoria(descripcion: 'Premio', color: Colors.lightGreen.value,  tipo: 'I').save();
        await Categoria(descripcion: 'Regalo', color: Colors.lightGreenAccent.value,  tipo: 'I').save();
        await Categoria(descripcion: 'Bono', color: Colors.teal.value,  tipo: 'I').save();
        await Categoria(descripcion: 'Otros Ingresos', color: Colors.greenAccent.value,  tipo: 'I').save();

        await Categoria(descripcion: 'Alimentación', color: Colors.blue.value,  tipo: 'E').save();
        await Categoria(descripcion: 'Combustible', color: Colors.purple.value,  tipo: 'E').save();
        await Categoria(descripcion: 'Deudas', color: Colors.red.value,  tipo: 'E').save();
        await Categoria(descripcion: 'Diezmo', color: Colors.lightGreen[300].value,  tipo: 'E').save();
        await Categoria(descripcion: 'Ofrenda', color: Colors.yellow.value,  tipo: 'E').save();
        await Categoria(descripcion: 'Ahorros', color: Colors.redAccent.value,  tipo: 'E').save();
        await Categoria(descripcion: 'Entretenimiento', color: Colors.limeAccent[700].value,  tipo: 'E').save();
        await Categoria(descripcion: 'Educación', color: Colors.lightGreen[900].value,  tipo: 'E').save();
        await Categoria(descripcion: 'Facturas', color: Colors.orange.value,  tipo: 'E').save();
        await Categoria(descripcion: 'Gastos Personales', color: Colors.teal[900].value,  tipo: 'E').save();
        await Categoria(descripcion: 'Gastos Varios', color: Colors.blueGrey.value,  tipo: 'E').save();
        await Categoria(descripcion: 'Casa', color: Colors.orangeAccent.value,  tipo: 'E').save();
        await Categoria(descripcion: 'Perdida', color: Colors.redAccent[400].value,  tipo: 'E').save();
        await Categoria(descripcion: 'Vestimenta', color: Colors.deepPurple.value,  tipo: 'E').save();
        await Categoria(descripcion: 'Salud', color: Colors.lightBlueAccent.value,  tipo: 'E').save();
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
      navigateAfterSeconds: new MyHomePage(),
      image: new Image.asset('assets/images/icono-app.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.blue,
    );
  }
}
