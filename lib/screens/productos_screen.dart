import 'package:flutter/material.dart';
import 'package:mi_bodeguita/screens/carrito_screen.dart';
import 'package:provider/provider.dart';
import 'package:mi_bodeguita/models/models.dart';
import 'package:mi_bodeguita/provider/producto_provider.dart';

class ProductosScreen extends StatefulWidget {
  Cliente cliente;
  CarritoModel carrito;
  ProductosScreen({this.cliente});

  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  @override
  Widget build(BuildContext context) {
    var productos = context.watch<ProductoProvider>().productos;
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarritoScreen()),
              );
            },
          )
        ],
      ),
      body: ListProductosWidget(productos: productos, cliente: widget.cliente),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showAddProductDialog(context);
        },
      ),
    );
  }

  void showAddProductDialog(BuildContext context) {
    TextEditingController _nombreController = TextEditingController();
    TextEditingController _precioController = TextEditingController();
    TextEditingController _descripcionController = TextEditingController();
    TextEditingController _cantidadController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Producto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de producto',
                  ),
                ),
                TextField(
                  controller: _precioController,
                  decoration: InputDecoration(
                    labelText: 'Precio',
                  ),
                ),
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripcion',
                  ),
                ),
                TextField(
                  controller: _cantidadController,
                  decoration: InputDecoration(
                    labelText: 'Cantidad a ingresar',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Agregar'),
              onPressed: () {
                context.read<ProductoProvider>().addProducto(
                      Producto(
                        nombre: _nombreController.text,
                        precio: double.parse(_precioController.text),
                        descripcion: _descripcionController.text,
                        stock: int.parse(_cantidadController.text),
                      ),
                    );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ListProductosWidget extends StatelessWidget {
  const ListProductosWidget({Key key, @required this.productos, this.cliente})
      : super(key: key);

  final List<Producto> productos;
  final Cliente cliente;

  @override
  Widget build(BuildContext context) {
    if (productos.length == 0) {
      return Center(
        child: Text('No hay productos'),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          for (Producto p in productos) ...[
            ProductoWidget(producto: p, cliente: cliente),
          ],
        ],
      ),
    );
  }
}

class ProductoWidget extends StatelessWidget {
  const ProductoWidget({Key key, this.producto, this.cliente})
      : super(key: key);

  final Producto producto;
  final Cliente cliente;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: FloatingActionButton(
                heroTag: producto.nombre,
                mini: true,
                child: Icon(Icons.add_shopping_cart_rounded),
                onPressed: () {
                  try {
                    CarritoModel.addPedido(Pedido(cliente.id, 1, producto));
                    showSnack(
                        context, '${producto.nombre} agregado al carrito');
                  } on Exception catch (e) {
                    showSnack(context, e.toString());
                  }
                },
              ),
              title: Text(producto.nombre),
              subtitle: Text('Precio: ${producto.precio}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit, size: 30),
                onPressed: () {
                  showEditProductoDialog(context, producto);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(producto.descripcion),
                  Text("Stock: " + producto.stock.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: 2),
      elevation: 10,
      backgroundColor: Colors.cyan,
    ));
  }

  void showEditProductoDialog(BuildContext context, Producto producto) {}
}
