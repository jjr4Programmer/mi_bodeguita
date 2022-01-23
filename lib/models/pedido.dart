import 'package:intl/intl.dart';
import 'package:mi_bodeguita/database.dart';
import 'package:mi_bodeguita/models/models.dart';

class Pedido extends Evento {
  int idCliente, cantidad;
  int id;
  Producto producto;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  BodegaDatabase _bd = BodegaDatabase();

  Pedido(this.idCliente, this.cantidad, this.producto) {
    this.monto = this.cantidad * producto.precio;
    List<String> fechaHora = dateFormat.format(DateTime.now()).split(' ');
    this.fecha = fechaHora[0];
    this.hora = fechaHora[1];
    print("Nuevo pedido ingresado: $cantidad - ${producto.precio} - $monto");
  }

  Map<String, dynamic> toMap() {
    return {
      "cliente_id": idCliente,
      "cantidad": cantidad,
      "costo": monto,
      "fecha": fecha,
      "hora": hora,
      "producto_id": producto.id,
    };
  }

  Pedido.fromMap(Map<String, dynamic> map) {
    this.idCliente = map['cliente_id'];
    this.cantidad = map['cantidad'];
    this.monto = map['costo'];
    this.fecha = map['fecha'];
    this.hora = map['hora'];
    this.id = map['id'];
    this.tipo = 'pedido';
    this.producto = _bd.getProducto(int.parse(map['producto_id'])) as Producto;
  }
}
