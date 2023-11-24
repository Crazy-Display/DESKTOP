import 'dart:async';

import 'package:flutter/material.dart';

class MyDialog {
  static Future<String?> mostrarDialogo(BuildContext context) async {
    final TextEditingController userController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    Completer<String?> completer = Completer<String?>();

    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Ingrese Usuario y Contraseña'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: userController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Usuario',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Contraseña',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
              completer.complete(null); // Resuelve el Future con null
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              String usuario = userController.text;
              String contrasenya = passController.text;
              String resultado = '{"type":"verify","username":"$usuario","password":"$contrasenya","from":"flutter"}';
              Navigator.of(context).pop(); // Cierra el diálogo
              completer.complete(resultado); // Resuelve el Future con el resultado
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );

    return completer.future;
  }
}
