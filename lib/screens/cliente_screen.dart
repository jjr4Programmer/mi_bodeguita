import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_bodeguita/database.dart';
import 'package:mi_bodeguita/models/models.dart';
import 'package:mi_bodeguita/screens/productos_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
        future: widget.db.getComprasPagosFromCliente(widget.cliente),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
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
                  if (snapshot.data[index] is Compra) {
                    return compraWidget(snapshot.data[index]);
                  } else {
                    return pagoWidget(snapshot.data[index] as Pago);
                  }
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
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 35.0),
        icon: Icons.add,
        activeIcon: Icons.close,
        heroTag: 'speed-dial-hero-tag',
        elevation: 8.0,
        backgroundColor: Colors.cyan,
        children: [
          SpeedDialChild(
            labelBackgroundColor: Colors.cyan,
            child: Icon(
              Icons.shopping_cart,
            ),
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            label: 'Nueva compra',
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductosScreen(cliente: widget.cliente)))
                  .whenComplete(() => setState(() {}));
            },
          ),
          SpeedDialChild(
            labelBackgroundColor: Colors.cyan,
            child: Icon(Icons.payments_sharp),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            label: 'Agregar pago',
            onTap: () => _addPago(),
          ),
        ],
      ),
    );
  }

  _addPago() {
    Cliente cliente = widget.cliente;
    TextEditingController pagoC = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              TextField(
                controller: pagoC,
                decoration: new InputDecoration(
                    icon: Icon(Icons.monetization_on_outlined),
                    labelText: "Ingrese monto"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Pago pago = Pago(cliente.id, double.parse(pagoC.text));
                      widget.db.insertPago(pago);
                      cliente.deuda -= pago.monto;
                      widget.db.updateCliente(cliente);
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Agregar pago"),
                ),
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
                Text("Fecha: ${compra.fecha} ${compra.hora}"),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _showDeleteCompra(compra),
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

  Widget pagoWidget(Pago pago) {
    return Card(
        color: Colors.blue.shade100,
        margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
        elevation: 10,
        child: Column(
          children: [
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        size: 25,
                        color: Colors.blue,
                      ),
                      Text(" ${pago.monto}"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 25,
                        color: Colors.blue,
                      ),
                      Text(" ${pago.fecha} ${pago.hora}"),
                    ],
                  ),
                ],
              ),
              leading: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _showDeletePago(pago),
              ),
            ),
          ],
        ));
  }

  Future<void> _showDeleteCompra(Compra compra) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar...'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Está segura que desea eliminar la compra?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                setState(() {
                  widget.db.deleteCompra(compra);
                  compra.cliente.deuda -= compra.monto;
                  widget.db.updateCliente(compra.cliente);
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

  Future<void> _showDeletePago(Pago pago) async {
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
                  widget.db.deletePago(pago);
                  widget.cliente.deuda += pago.monto;
                  widget.db.updateCliente(widget.cliente);
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
}
