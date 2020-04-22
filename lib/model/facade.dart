import 'package:complex/constant/Utils.dart';
import 'package:complex/model/model.dart';
import 'package:complex/model/querys.dart';

class Facade {
  static Future<List<Map<String, dynamic>>> saldoMes(String fecha) async {
    List<Map<String, dynamic>> data =
        await DbComplex().execDataTable(Querys.saldoMes(fecha));
    return data;
  }

  static Future<List<Map<String, dynamic>>> gastosCategoria(
      String fecha) async {
    List<Map<String, dynamic>> data =
        await DbComplex().execDataTable(Querys.gastosCategoria(fecha));
    return data;
  }

  static Future<List<Map<String, dynamic>>> historialGastos(
      String fecha) async {
    List<Map<String, dynamic>> data =
        await DbComplex().execDataTable(Querys.historialGastos(fecha));
    return data;
  }

  static Future<Map<String, int>> balanceMes(String fecha) async {
    Map<String, dynamic> data = new Map<String, int>();
    int ingresos = 0;
    int egresos = 0;
    int balance = 0;
    List<DetallesCuenta> detalleList = await DetallesCuenta()
        .select()
        .cuentasIdCuenta
        .equals(1)
        .and
        .fecha
        .startsWith(fecha)
        .orderByDesc("fecha")
        .toList();

    for (DetallesCuenta detalle in detalleList) {
      if (detalle.tipoTransaccion == 'I') {
        ingresos = ingresos + detalle.monto.toInt();
      }
      if (detalle.tipoTransaccion == 'E') {
        egresos = egresos + detalle.monto.toInt();
      }
    }
    balance = ingresos - egresos;
    data["ingresos"] = ingresos;
    data["egresos"] = egresos;
    data["balance"] = balance;
    return data;
  }

  static Future<Map<String, int>> cuentaSaldo(String fecha) async {
    Map<String, dynamic> data = new Map<String, int>();
    int ingresos = 0;
    int egresos = 0;
    int saldo = 0;
    List<DetallesCuenta> detalleList = await DetallesCuenta()
        .select()
        .cuentasIdCuenta
        .equals(1)
        .and
        .fecha
        .startsWith(fecha)
        .orderByDesc("fecha")
        .toList();

    for (DetallesCuenta detalle in detalleList) {
      if (detalle.tipoTransaccion == 'I') {
        ingresos = ingresos + detalle.monto.toInt();
      }
      if (detalle.tipoTransaccion == 'E') {
        egresos = egresos + detalle.monto.toInt();
      }
    }

    final saldoData = await saldoMes(fecha);
    if (saldoData.length > 0) {
      saldo = UtilsFormat.doubleToInt(saldoData[0]["saldo"]);
    }

    data["ingresos"] = ingresos;
    data["egresos"] = egresos;
    data["saldo"] = saldo;
    return data;
  }
}
