class Querys {
  static String historialGastos(String fecha) {
    return "select a.fecha,sum(a.monto) as monto from detallesCuenta a where a.fecha like '${fecha}%' and a.tipoTransaccion = 'E' group by a.fecha";
  }

  static String gastosCategoria(String fecha) {
    return "SELECT a.porcentaje, a.monto, b.descripcion , b.color from (select round((a.monto * 100) / i.total) as porcentaje, a.categoriasIdCategoria,a.monto from (select a.categoriasIdCategoria,a.cuentasIdCuenta,sum(a.monto) as monto from detallesCuenta a where a.fecha like '${fecha}%' and a.tipoTransaccion = 'E' group by a.categoriasIdCategoria,a.cuentasIdCuenta order by sum(a.monto) desc) a inner join (select e.cuentasIdCuenta, sum(e.monto) as total from detallesCuenta e where e.fecha like '${fecha}%' and e.tipoTransaccion = 'E' group by e.cuentasIdCuenta) i on (a.cuentasIdCuenta = i.cuentasIdCuenta)) a inner join categorias b on (a.categoriasIdCategoria = b.idCategoria)";
  }

  static String balanceMes(String fecha) {
    return "SELECT a.ingresos,b.egresos,(a.ingresos - b.egresos) as balance from (select sum(monto) as ingresos from detallesCuenta WHERE fecha like '${fecha}%' and tipoTransaccion = 'I' group by fecha) a, (select sum(monto) as egresos from detallesCuenta WHERE fecha like '${fecha}%' and tipoTransaccion = 'E' group by fecha) b";
  }
}
