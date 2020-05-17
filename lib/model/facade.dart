import 'package:complex/constant/Utils.dart';
import 'package:complex/model/model.dart';
import 'package:complex/model/querys.dart';

class Facade {
  static Future<List<Categoria>> getCategory(String tipoForm) async {
    return await Categoria().select().tipo.equals(tipoForm).toList();
  }

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

  static Future<Map<String, dynamic>> datosMeta(Meta meta) async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    int porcentaje = 0;
    double depositado = 0;
    int diasFaltantes = 0;
    double ahorrar = 0;

    double diffMes = 0;

    List<Map<String, dynamic>> detalle = await DbComplex()
        .execDataTable(Querys.metaTotalDepositado(meta.idMeta));

    if ((detalle.length > 0) && detalle[0]["depositado"] != null) {
      depositado = detalle[0]["depositado"];
      porcentaje = ((depositado * 100) / meta.montoFinal).round();
    }

    DateTime hoy = new DateTime.now();
    DateTime fin = DateTime.parse(meta.fechaFin);
    var difference = fin.difference(hoy);
    diasFaltantes = difference.inDays;

    if (diasFaltantes > 30) {
      diffMes = (diasFaltantes / 30);
      ahorrar = ((meta.montoFinal - depositado) / diffMes).floorToDouble();
    } else {
      ahorrar = ((meta.montoFinal - depositado) / 30).floorToDouble();
    }

    data["porcentaje"] = porcentaje;
    data["depositado"] = depositado;
    data["diasFaltantes"] = diasFaltantes;
    data["ahorrar"] = ahorrar;

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
    if (saldoData.length > 0 && saldoData[0]["saldo"] != null) {
      saldo = UtilsFormat.doubleToInt(saldoData[0]["saldo"]);
    }

    data["ingresos"] = ingresos;
    data["egresos"] = egresos;
    data["saldo"] = saldo;
    return data;
  }
}
