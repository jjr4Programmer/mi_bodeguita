import 'package:mi_bodeguita/models/models.dart';

class CarritoModel {
  static List<Pedido> _pedidos = [];
  static Cliente cliente;

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

  static grabarcompra() {
    if (cliente == null) {
      throw Exception('No hay cliente');
    }
    if (_pedidos.isEmpty) {
      throw Exception('No hay pedidos');
    }
    //Grabamos la compra en el cliente
    double total = 0;
    for (Pedido p in _pedidos) {
      total += p.producto.precio * p.cantidad;
    }
    cliente.deuda += total;
    cliente.updateOnDb();
    // Grabamos compra
    Compra compra = Compra(cliente, total, _pedidos);
    compra.grabar().whenComplete(() {
      for (Pedido p in _pedidos) {
        p.compra = compra;
        p.grabar();
      }
      // Limpiar carrito
      cliente = null;
      _pedidos.clear();
    });
  }
}
