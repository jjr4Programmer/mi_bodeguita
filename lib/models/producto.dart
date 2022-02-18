import 'package:mi_bodeguita/database.dart';

class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;
  int stock;
  BodegaDatabase _bd = BodegaDatabase();

  Producto(
      {this.id,
      this.nombre,
      this.descripcion,
      this.precio,
      this.imagen,
      this.stock});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'imagen': imagen,
      'stock': stock
    };
  }

  Producto.fromMap(Map<String, dynamic> json)
      : id = json['id'] as int,
        nombre = json['nombre'],
        descripcion = json['descripcion'],
        precio = json['precio'],
        imagen = json['imagen'],
        stock = json['stock'];

  void updateOnDb() {
    _bd.updateProducto(this);
  }
}
