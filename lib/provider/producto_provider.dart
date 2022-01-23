import 'package:flutter/material.dart';
import 'package:mi_bodeguita/database.dart';
import '../models/producto.dart';

class ProductoProvider with ChangeNotifier {
  BodegaDatabase _bd = BodegaDatabase();
  List<Producto> _productos = [];
  ProductoProvider() {
    _bd.getAllProductos().then((movies) {
      _productos = movies;
      notifyListeners();
    });
  }
  // Retrieve all movies
  List<Producto> get productos => _productos;

  void addProducto(Producto producto) {
    _bd.insertProducto(producto);
    _bd.getAllProductos().then((productos) {
      _productos = productos;
      notifyListeners();
    });
  }
}
