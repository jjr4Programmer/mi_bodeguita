import 'package:flutter/material.dart';
import 'package:mi_bodeguita/models/models.dart';
import 'package:mi_bodeguita/utils.dart';

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
      body: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (CarritoModel.pedidos.isEmpty) ...{
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Sin pedidos",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                } else ...{
                  for (Pedido pedido in CarritoModel.pedidos) ...{
                    getPedidoWidget(pedido),
                  }
                }
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total: S/ ${CarritoModel.total}',
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                child: Text('Comprar'),
                onPressed: () {
                  try {
                    CarritoModel.grabarcompra();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } on Exception catch (e) {
                    showSnack(context, e.toString());
                  }
                },
              )
            ],
          ),
        ),
      ]),
    );
  }

  getPedidoWidget(Pedido pedido) {
    return Card(
      shadowColor: Colors.blue,
      elevation: 5,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text(pedido.producto.nombre),
            title: Text(pedido.producto.precio.toString()),
            subtitle: Text(pedido.producto.descripcion),
            trailing: IconButton(
              icon: const Icon(Icons.delete, size: 30),
              onPressed: () {
                CarritoModel.removePedido(pedido);
                setState(() {});
              },
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border.all(color: Colors.black),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (pedido.cantidad == 1) {
                        CarritoModel.removePedido(pedido);
                      } else {
                        pedido.cantidad--;
                      }
                      setState(() {});
                    },
                    child: const Icon(Icons.remove),
                  ),
                  Text(
                    pedido.cantidad.toString(),
                    style: TextStyle(fontSize: 20),
                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}
