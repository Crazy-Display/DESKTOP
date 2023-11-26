import 'package:flutter/material.dart';

void mostrarListaEnDialog(BuildContext context, List<String> lista) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Users connected'),
        content: Column(
          children: [
            for (String elemento in lista)
              ListTile(
                title: Text(elemento),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cerrar'),
          ),
        ],
      );
    },
  );
}