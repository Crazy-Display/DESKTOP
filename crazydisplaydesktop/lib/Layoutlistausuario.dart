import 'package:crazydisplaydesktop/Lista.dart';
import 'package:flutter/material.dart';

class ListaDialog extends StatefulWidget {
  final List<String> lista;

  ListaDialog({required this.lista});

  @override
  _ListaDialogState createState() => _ListaDialogState();
}

class _ListaDialogState extends State<ListaDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Users connected'),
      content: Column(
        children: [
          for (String elemento in widget.lista)
            ListTile(
              title: Text(elemento),
            ),
        ],
      ),
      actions: [TextButton(
          onPressed: () {
            setState(() {
              widget.lista;
            });
          },
          child: Text('Reload'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cerrar'),
        ),
      ],
    );
  }
}

void mostrarListaEnDialog(BuildContext context, List<String> lista) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ListaDialog(lista: lista);
    },
  );
}
