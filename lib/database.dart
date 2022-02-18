import 'package:sqflite/sqflite.dart';

import 'models/models.dart';

class BodegaDatabase {
  static Database chelitappDb;

  init() async {
    if (chelitappDb == null) {
      chelitappDb = await openDatabase('mi_bodeguita.db',
          version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    }
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {}
  }

  _onCreate(Database db, int version) {
    db.execute(
        "CREATE TABLE cliente (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, deuda REAL)");
    db.execute(
        "CREATE TABLE producto (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, precio REAL NOT NULL, descripcion TEXT, imagen TEXT, stock INTEGER)");
    db.execute(
        "CREATE TABLE pedido (id INTEGER PRIMARY KEY AUTOINCREMENT, compra_id INTEGER NOT NULL, cantidad INTEGER, producto_id INTEGER, FOREIGN KEY(producto_id) REFERENCES producto(id))");
    db.execute(
        "CREATE TABLE pago (id INTEGER PRIMARY KEY AUTOINCREMENT, cliente_id INTEGER NOT NULL, monto REAL, fecha TEXT, hora TEXT)");
    db.execute(
        "CREATE TABLE compra (id INTEGER PRIMARY KEY AUTOINCREMENT, cliente_id INTEGER NOT NULL, monto REAL NOT NULL, fecha TEXT, hora TEXT)");
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

  Future<int> insertCompra(Compra compra) async {
    int id = await chelitappDb.insert("compra", compra.toMap());
    return id;
  }

  Future deleteCompra(Compra compra) async {
    chelitappDb.delete("compra", where: "id=?", whereArgs: [compra.id]);
  }

  Future insertPago(Pago pago) async {
    chelitappDb.insert("pago", pago.toMap());
  }

  Future<List<Pago>> getPagosFromCliente(Cliente cliente) async {
    List<Map<String, dynamic>> resultsPag = await chelitappDb
        .query("pago", where: "cliente_id=?", whereArgs: [cliente.id]);
    List<Pago> pagos = resultsPag.map((map) => Pago.fromMap(map)).toList();
    return pagos;
  }

  Future<List<Cliente>> getAllClientes() async {
    List<Map<String, dynamic>> results = await chelitappDb.query("cliente");
    return results.map((map) => Cliente.fromMap(map)).toList();
  }

  Future<Cliente> getCliente(int idCliente) async {
    List<Map<String, dynamic>> results = await chelitappDb
        .query("cliente", where: "id=?", whereArgs: [idCliente]);
    return results.map((map) => Cliente.fromMap(map)).toList()[0];
  }

  Future<List<Pedido>> getPedidosFromCompra(Compra compra) async {
    List<Map<String, dynamic>> results = await chelitappDb
        .query("pedido", where: "compra_id=?", whereArgs: [compra.id]);
    return results.map((map) => Pedido.fromMap(map)).toList();
  }

  Future<List<Compra>> getComprasFromCliente(Cliente cliente) async {
    List<Map<String, dynamic>> results = await chelitappDb
        .query("compra", where: "cliente_id=?", whereArgs: [cliente.id]);
    List<Compra> compras = results.map((map) => Compra.fromMap(map)).toList();
    for (Compra compra in compras) {
      List<Pedido> pedidos = await getPedidosFromCompra(compra);
      for (Pedido pedido in pedidos) {
        pedido.producto = await getProducto(pedido.idProducto);
      }
      compra.pedidos = pedidos;
      compra.cliente = cliente;
    }
    return compras;
  }

  Future<List<dynamic>> getComprasPagosFromCliente(Cliente cliente) async {
    List<Compra> compras = await getComprasFromCliente(cliente);
    List<Pago> pagos = await getPagosFromCliente(cliente);
    List<dynamic> comprasPagos = [];
    comprasPagos.addAll(compras);
    comprasPagos.addAll(pagos);
    comprasPagos.sort((a, b) => a.compareTo(b));
    return comprasPagos;
  }

  Future updateCliente(Cliente cliente) async {
    chelitappDb.update("cliente", cliente.toMap(),
        where: "id=?", whereArgs: [cliente.id]);
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
