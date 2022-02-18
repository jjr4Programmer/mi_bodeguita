import 'package:mi_bodeguita/database.dart';
import 'package:mi_bodeguita/models/models.dart';

class Pedido {
  int cantidad;
  int id;
  int idProducto;
  Producto producto;
  Compra compra;
  Cliente cliente;
  BodegaDatabase _bd = BodegaDatabase();

  Pedido(this.cliente, this.cantidad, this.producto);

  Map<String, dynamic> toMap() {
    return {
      "cantidad": cantidad,
      "producto_id": producto.id,
      "compra_id": compra.id,
    };
  }

  Pedido.fromMap(Map<String, dynamic> map) {
    this.cantidad = map['cantidad'];
    this.id = map['id'];
    this.idProducto = map['producto_id'];
  }

  void grabar() {
    _bd.insertPedido(this);
    producto.stock -= cantidad;
    producto.updateOnDb();
  }
}
