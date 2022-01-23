import 'package:flutter/material.dart';
import 'package:mi_bodeguita/models/models.dart';

class CarritoScreen extends StatefulWidget {
  CarritoScreen({Key key}) : super(key: key);

  @override
  _CarritoScreenState createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de compras'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (Pedido pedido in CarritoModel.pedidos) ...[
              getPedidoWidget(pedido),
            ]
          ],
        ),
      ),
    );
  }

  getPedidoWidget(Pedido pedido) {
    return Card(
      child: Column(
        children: <Widget>[
          Text(pedido.producto.nombre),
          Text(pedido.producto.precio.toString()),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    pedido.cantidad--;
                  });
                },
                child: const Icon(Icons.remove),
              ),
              Text(pedido.cantidad.toString()),
              InkWell(
                onTap: () {
                  setState(() {
                    pedido.cantidad++;
                  });
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
