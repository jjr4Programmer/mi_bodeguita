import 'package:flutter/material.dart';
import 'package:mi_bodeguita/provider/producto_provider.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(ChangeNotifierProvider<ProductoProvider>(
    child: BodeguitaApp(),
    create: (_) => ProductoProvider(), // Create a new ChangeNotifier object
  ));
}

class BodeguitaApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi bodeguita',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: HomeScreen(),
    );
  }
}
