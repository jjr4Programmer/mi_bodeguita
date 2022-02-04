import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_bodeguita/database.dart';
import 'package:mi_bodeguita/models/models.dart';
import 'package:mi_bodeguita/screens/productos_screen.dart';

class ClienteScreen extends StatefulWidget {
  ClienteScreen({Key key, this.title, this.cliente, this.db}) : super(key: key);
  final String title;
  final Cliente cliente;
  final BodegaDatabase db;

  @override
  _ClienteScreen createState() => _ClienteScreen();
}

class _ClienteScreen extends State<ClienteScreen> {
  @override
  Widget build(BuildContext context) {
    CarritoModel.cliente = widget.cliente;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: widget.db.getComprasFromCliente(widget.cliente),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data.isEmpty) {
                  return Center(
                    child: Text("No registra compras"),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return compraWidget(snapshot.data[index] as Compra);
                  },
                );
              } else {
                return Center(
                  child: Text("Error al obtener compras"),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductosScreen(cliente: widget.cliente)))
                .whenComplete(() => setState(() {}));
          },
        ));
  }

  _addPago() {
    Cliente cliente = widget.cliente;
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              TextField(
                decoration: new InputDecoration(
                    icon: Icon(Icons.monetization_on_outlined),
                    labelText: "Ingrese monto"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSubmitted: (text) {
                  setState(() {
                    Pago pago = Pago(cliente.id, double.parse(text));
                    widget.db.insertPago(pago);
                    cliente.deuda -= pago.monto;
                    widget.db.updateCliente(cliente);
                    Navigator.pop(context);
                  });
                },
              )
            ],
          );
        });
  }

  compraWidget(Compra compra) {
    return Card(
      margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
      elevation: 10,
      child: Column(
        children: [
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Compra: ${compra.monto}"),
                Text("Fecha: ${compra.fecha}"),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  widget.db.deleteCompra(compra);
                  widget.cliente.deuda -= compra.monto;
                  widget.db.updateCliente(widget.cliente);
                });
              },
            ),
          ),
          Divider(
            height: 10,
            thickness: 2,
            indent: 10,
            endIndent: 10,
          ),
          Wrap(
            spacing: 10,
            children: [
              for (Pedido pedido in compra.pedidos) ...[
                Container(
                  margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text("${pedido.producto.nombre} (${pedido.cantidad})")
                    ],
                  ),
                ),
              ],
            ],
          ),
          Divider(
            height: 10,
            thickness: 2,
            indent: 10,
            endIndent: 10,
          ),
        ],
      ),
    );
  }

  /* Future<void> _showDeletePedido(Pedido pedido, Cliente cliente) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar...'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Está segura que desea eliminar el pedido?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                print(" ------ Monto: " + pedido.monto.toString());
                setState(() {
                  cliente.deuda -= pedido.monto;
                  widget.db.updateCliente(cliente);
                  widget.db.deletePedido(pedido);
                  Navigator.of(context).pop();
                });
              },
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeletePago(Pago pago, Cliente cliente) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar...'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Está segura que desea eliminar el pago?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                setState(() {
                  cliente.deuda += pago.monto;
                  widget.db.updateCliente(cliente);
                  widget.db.deletePago(pago);
                  Navigator.of(context).pop();
                });
              },
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
 */
  /* _addPedido2() {
    Cliente cliente = widget.cliente;
    double pCerveza = 6.0;
    int cantidad = 0;
    Alert(
        context: context,
        title: "Nuedo pedido",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  icon: Icon(Icons.liquor), labelText: "Cantidad de cervezas"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (text) {
                setState(() {
                  cantidad = text != '' ? int.parse(text) : 0;
                });
              },
            ),
            TextField(
              controller: TextEditingController(text: pCerveza.toString()),
              decoration: InputDecoration(
                  icon: Icon(Icons.monetization_on_outlined),
                  labelText: "Precio"),
              keyboardType: TextInputType.number,
              onChanged: (text) {
                setState(() {
                  pCerveza = text != '' ? double.parse(text) : 0.0;
                });
              },
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              setState(() {
                if (cantidad > 0 && pCerveza > 0) {
                  Pedido pedido = Pedido(cliente.id, cantidad, pCerveza);
                  widget.db.insertPedido(pedido);
                  cliente.deuda += pCerveza * cantidad;
                  widget.db.updateCliente(cliente);
                  Navigator.pop(context);
                }
              });
            },
            child: Text(
              "Agregar pedido",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
 */
}
