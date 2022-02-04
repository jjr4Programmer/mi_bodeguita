import 'package:intl/intl.dart';
import 'package:mi_bodeguita/database.dart';
import 'package:mi_bodeguita/models/models.dart';

class Compra extends Evento {
  int id;
  Cliente cliente;
  double monto;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  List<Pedido> pedidos;
  BodegaDatabase _bd = BodegaDatabase();

  Compra(this.cliente, this.monto, this.pedidos) {
    List<String> fechaHora = dateFormat.format(DateTime.now()).split(' ');
    this.fecha = fechaHora[0];
    this.hora = fechaHora[1];
  }

  Compra.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        monto = map['monto'] {
    fecha = map['fecha'];
    hora = map['hora'];
    cliente = CarritoModel.cliente;
  }

  Map<String, Object> toMap() {
    return {
      'id': id,
      'cliente_id': cliente.id,
      'monto': monto,
      'fecha': fecha,
      'hora': hora,
    };
  }

  grabar() async {
    int id = await _bd.insertCompra(this);
    this.id = id;
  }
}
