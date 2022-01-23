import 'package:sqflite/sqflite.dart';

import 'models/models.dart';

class BodegaDatabase {
  static Database chelitappDb;

  init() async {
    if (chelitappDb == null) {
      chelitappDb = await openDatabase('mi_bodeguita.db',
          version: 4, onCreate: _onCreate, onUpgrade: _onUpgrade);
    }
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
      // you can execute drop table and create table
      db.execute(
          "CREATE TABLE producto (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, precio REAL NOT NULL, descripcion TEXT, imagen TEXT, stock INTEGER)");
    }
  }

  _onCreate(Database db, int version) {
    db.execute(
        "CREATE TABLE cliente (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, deuda REAL)");
    db.execute(
        "CREATE TABLE pedido (id INTEGER PRIMARY KEY AUTOINCREMENT, cliente_id INTEGER NOT NULL, cantidad INTEGER, costo REAL, fecha TEXT, hora TEXT)");
    db.execute(
        "CREATE TABLE pago (id INTEGER PRIMARY KEY AUTOINCREMENT, cliente_id INTEGER NOT NULL, monto REAL, fecha TEXT, hora TEXT)");
    db.execute(
        "CREATE TABLE producto (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, precio REAL NOT NULL, descripcion TEXT, imagen TEXT, stock INTEGER)");
  }

  Future insertCliente(Cliente cliente) async {
    chelitappDb.insert("cliente", cliente.toMap());
  }

  Future insertPedido(Pedido pedido) async {
    chelitappDb.insert("pedido", pedido.toMap());
  }

  Future deleteCliente(Cliente cliente) async {
    chelitappDb.delete("cliente", where: "id=?", whereArgs: [cliente.id]);
  }

  Future deletePedido(Pedido pedido) async {
    chelitappDb.delete("pedido", where: "id=?", whereArgs: [pedido.id]);
  }

  Future deletePago(Pago pago) async {
    chelitappDb.delete("pago", where: "id=?", whereArgs: [pago.id]);
  }

  Future<List<dynamic>> getAllEventosCliente(int idCliente) async {
    List<Map<String, dynamic>> resultsPed = await chelitappDb
        .query("pedido", where: "cliente_id=?", whereArgs: [idCliente]);
    List<Pedido> pedidos =
        resultsPed.map((map) => Pedido.fromMap(map)).toList();
    List<Map<String, dynamic>> resultsPag = await chelitappDb
        .query("pago", where: "cliente_id=?", whereArgs: [idCliente]);
    List<Pago> pagos = resultsPag.map((map) => Pago.fromMap(map)).toList();
    var eventos = new List.empty(growable: true);
    eventos.addAll(pedidos);
    eventos.addAll(pagos);
    eventos.sort((a, b) => (a.fecha + a.hora).compareTo(b.fecha + b.hora));
    return eventos;
  }

  Future<List<Cliente>> getAllClientes() async {
    List<Map<String, dynamic>> results = await chelitappDb.query("cliente");
    return results.map((map) => Cliente.fromMap(map)).toList();
  }

  Future<List<Cliente>> getCliente(int idCliente) async {
    List<Map<String, dynamic>> results = await chelitappDb
        .query("cliente", where: "id=?", whereArgs: [idCliente]);
    return results.map((map) => Cliente.fromMap(map)).toList();
  }

  Future<List<Pedido>> getPedidosCliente(int idCliente) async {
    List<Map<String, dynamic>> results = await chelitappDb
        .query("pedido", where: "cliente_id=?", whereArgs: [idCliente]);
    return results.map((map) => Pedido.fromMap(map)).toList();
  }

  Future updateCliente(Cliente cliente) async {
    chelitappDb.update("cliente", cliente.toMap(),
        where: "id=?", whereArgs: [cliente.id]);
  }

  insertPago(Pago pago) {
    chelitappDb.insert("pago", pago.toMap());
  }

  Future<List<Producto>> getAllProductos() async {
    List<Map<String, dynamic>> results = await chelitappDb.query("producto");
    return results.map((map) => Producto.fromMap(map)).toList();
  }

  Future<Producto> getProducto(int idProducto) async {
    List<Map<String, dynamic>> results = await chelitappDb
        .query("producto", where: "id=?", whereArgs: [idProducto]);
    final result = results.map((map) => Producto.fromMap(map)).toList();
    return result[0];
  }

  insertProducto(Producto producto) {
    chelitappDb.insert("producto", producto.toMap());
  }

  Future updateProducto(Producto producto) async {
    chelitappDb.update("producto", producto.toMap(),
        where: "id=?", whereArgs: [producto.id]);
  }
}
