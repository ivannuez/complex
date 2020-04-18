import 'package:flutter/foundation.dart';
import 'package:complex/model/model.dart';

class MainProvider with ChangeNotifier {
//Creamos una clase "MyProvider" y le agregamos las capacidades de Change Notifier.
/*
La propiedad WITH
Un mixin se refiere a  agregar las capacidades de otra clase o clases a nuestra propia clase,
sin heredar de esas clases. Los métodos de esas clases ahora pueden llamarse en su clase, y el código
dentro de esas clases se ejecutará. Dart no tiene herencia múltiple, pero el uso de mixins le permite
plegarse en otras clases para lograr la reutilización del código y evitar los problemas que podría causar
la herencia múltiple.
*/
  String _usuario;
  int _usuarioId = 0;
  int _cuentaId = 0;
  int _grupoId = 0;

  int _ingresoTotal = 0;
  int _egresoTotal = 0;
  int _saldo = 0;
  
  String _mesActualHome;
  String _mesActualTransaction;

  String get usuario => _usuario;
  set usuario(String value) {
    _usuario = value;
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }

  int get usuarioId => _usuarioId;
  set usuarioId(int value) {
    _usuarioId = value;
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }

  int get cuentaId => _cuentaId;
  set cuentaId(int value) {
    _cuentaId = value;
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }

  int get grupoId => _grupoId;
  set grupoId(int value) {
    _grupoId = value;
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }

  int get ingresoTotal => _ingresoTotal;
  set ingresoTotal(int value) {
    _ingresoTotal = value;
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }

  int get egresoTotal => _egresoTotal;
  set egresoTotal(int value) {
    _egresoTotal = value;
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }

  int get saldo => _saldo;
  set saldo(int value) {
    _saldo = value;
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }

  String get mesActualHome => _mesActualHome;
  set mesActualHome(String value) {
    _mesActualHome = value;
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }

  String get mesActualTransaction => _mesActualTransaction;
  set mesActualTransaction(String value) {
    _mesActualTransaction = value;
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }


  void initialState(String usuario, int usuarioId, int cuentaId,
      int ingresoTotal, int egresoTotal, int saldo) {
    _usuario = usuario;
    _usuarioId = usuarioId;
    _cuentaId = cuentaId;
    _ingresoTotal = ingresoTotal;
    _egresoTotal = egresoTotal;
    _saldo = saldo;
    notifyListeners();
  }

  void updateIngreso(int ingresoTotal, int saldo) {
    _ingresoTotal = ingresoTotal;
    _saldo = saldo;
    notifyListeners();
  }

  void updateEgreso(int egresoTotal, int saldo) {
    _egresoTotal = egresoTotal;
    _saldo = saldo;
    notifyListeners();
  }
}
