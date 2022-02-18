import 'package:flutter/material.dart';

void showSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    duration: Duration(seconds: 2),
    elevation: 10,
    backgroundColor: Colors.cyan,
  ));
}
