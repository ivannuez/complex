import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

/*
const grupos = SqfEntityTable(
  tableName: 'grupos',
  primaryKeyName: 'idGrupo',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('descripcion', DbType.text),
  ],
);
*/



/*
const usuariosGrupos = SqfEntityTable(
  tableName: 'usuariosGrupos',
  fields: [
    SqfEntityFieldRelationship(
        parentTable: usuarios,
        relationType: RelationType.MANY_TO_MANY,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: '0'),
    SqfEntityFieldRelationship(
        parentTable: grupos,
        relationType: RelationType.MANY_TO_MANY,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: '0'),
  ],
);
*/

const usuarios = SqfEntityTable(
  tableName: 'usuarios',
  primaryKeyName: 'idUsuario',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('nombre', DbType.text),
  ],
);

/*const colores = SqfEntityTable(
  tableName: 'colores',
  primaryKeyName: 'idColor',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('descripcion', DbType.text),
    SqfEntityField('valor', DbType.text),
  ],
);*/

/*const iconos = SqfEntityTable(
  tableName: 'iconos',
  primaryKeyName: 'idIcono',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('descripcion', DbType.text),
    SqfEntityField('valor', DbType.text),
  ],
);*/

const categorias = SqfEntityTable(
  tableName: 'categorias',
  primaryKeyName: 'idCategoria',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('descripcion', DbType.text),
    SqfEntityField('color', DbType.integer, defaultValue: 0),
    SqfEntityField('icono', DbType.text),
    SqfEntityField('tipo', DbType.text),
  ],
);

const cuentas = SqfEntityTable(
  tableName: 'cuentas',
  primaryKeyName: 'idCuenta',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('descripcion', DbType.text),
    SqfEntityField('saldo', DbType.real, defaultValue: 0),
    SqfEntityField('totalIngreso', DbType.real, defaultValue: 0),
    SqfEntityField('totalEgreso', DbType.real, defaultValue: 0),
    SqfEntityFieldRelationship(
        parentTable: usuarios,
        deleteRule: DeleteRule.SET_NULL,
        defaultValue: '0'),
  ],
);

const detallesCuenta = SqfEntityTable(
  tableName: 'detallesCuenta',
  primaryKeyName: 'idDetalleCuenta',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('descripcion', DbType.text),
    SqfEntityField('fecha', DbType.text),
    SqfEntityField('monto', DbType.real, defaultValue: 0),
    SqfEntityField('tipoTransaccion', DbType.text),
    SqfEntityFieldRelationship(
        parentTable: cuentas,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: '0'),
    SqfEntityFieldRelationship(
        parentTable: categorias,
        deleteRule: DeleteRule.SET_NULL,
        defaultValue: '0'),
  ],
);



const metas = SqfEntityTable(
  tableName: 'metas',
  primaryKeyName: 'idMeta',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('descripcion', DbType.text),
    SqfEntityField('fechaInicio', DbType.text),
    SqfEntityField('fechaFin', DbType.text),
    SqfEntityField('montoInicial', DbType.real, defaultValue: 0),
    SqfEntityField('montoFinal', DbType.real, defaultValue: 0),
    SqfEntityField('color', DbType.text),
    SqfEntityField('icono', DbType.text),
  ],
);

const detallesMetas = SqfEntityTable(
  tableName: 'detallesMetas',
  primaryKeyName: 'idDetalleMeta',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('fecha', DbType.text),
    SqfEntityField('monto', DbType.real, defaultValue: 0),
    SqfEntityFieldRelationship(
        parentTable: metas,
        deleteRule: DeleteRule.CASCADE,
        defaultValue: '0'),
  ],
);

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
    modelName: 'DbComplex', // optional
    databaseName: 'complex.db',
    databaseTables: [usuarios,categorias,cuentas,detallesCuenta,metas,detallesMetas],
    bundledDatabasePath: null);
