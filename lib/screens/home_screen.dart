import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mi_bodeguita/database.dart';
import 'package:mi_bodeguita/models/models.dart';
import 'package:mi_bodeguita/screens/cliente_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BodegaDatabase db = BodegaDatabase();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mi Bodeguita"),
        actions: [],
      ),
      body: FutureBuilder(
        future: db.init(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return showListClients(context);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _addClient,
          tooltip: 'Agregar nuevo cliente',
          icon: Icon(Icons.person_add),
          label: Text(
              'Nuevo cliente')), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _addClient() {
    TextEditingController _nombreController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                    icon: Icon(Icons.person_add),
                    labelText: "Nombre de cliente"),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  child: Text("Agregar"),
                  onPressed: () {
                    setState(() {
                      db.insertCliente(Cliente(_nombreController.text));
                      Navigator.pop(context);
                    });
                  },
                ),
              )
            ],
          );
        });
  }

  showListClients(BuildContext context) {
    return FutureBuilder(
      future: db.getAllClientes(),
      builder: (BuildContext context, AsyncSnapshot<List<Cliente>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text("Sin clientes"),
            );
          }
          return ListView(
            children: <Widget>[
              for (Cliente cliente in snapshot.data)
                InkWell(
                  child: Card(
                    margin: EdgeInsets.fromLTRB(25, 10, 25, 0),
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(cliente.nombre),
                      subtitle: Text("Deuda: " + cliente.deuda.toString()),
                    ),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => ClienteScreen(
                              title: 'Cliente ' + cliente.nombre,
                              cliente: cliente,
                              db: db,
                            ));
                    Navigator.push(context, route).then(_stateUpdate);
                  },
                  onLongPress: () {
                    _showDeleteCliente(cliente).then(_stateUpdate);
                  },
                ),
            ],
          );
        } else {
          return Center(
            child: Text("Cargando..."),
          );
        }
      },
    );
  }

  FutureOr _stateUpdate(dynamic value) {
    setState(() {});
  }

  Future<void> _showDeleteCliente(Cliente cliente) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar...'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                    'Está segura que desea eliminar a ' + cliente.nombre + '?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirmar'),
              onPressed: () {
                db.deleteCliente(cliente);
                Navigator.of(context).pop();
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
