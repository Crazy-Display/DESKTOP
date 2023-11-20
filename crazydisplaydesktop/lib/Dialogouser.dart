import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class Dialogouser extends StatelessWidget {
  const Dialogouser({Key? key}) : super(key: key);

  static Future<String> mostrarDialogo(BuildContext context) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Identificate'),
        content: TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Usuario',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
    
    
    return "correcto";
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => mostrarDialogo(context),
      child: const Text('Show Dialog'),
    );
  }
}