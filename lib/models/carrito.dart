import 'package:mi_bodeguita/models/models.dart';

class CarritoModel {
  static List<Pedido> _pedidos = [];

  CarritoModel();

  static List<Pedido> get pedidos => _pedidos;

  static addPedido(Pedido pedido) {
    if (_pedidos.any((p) => p.producto.id == pedido.producto.id)) {
      throw Exception('El pedido ya existe');
    }
    _pedidos.add(pedido);
  }

  static removePedido(Pedido pedido) {
    _pedidos.remove(pedido);
  }

  static double get total {
    double total = 0;
    for (Pedido pedido in _pedidos) {
      total += pedido.producto.precio * pedido.cantidad;
    }
    return total;
  }
}
