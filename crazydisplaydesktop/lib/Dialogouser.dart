import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class Dialogouser extends StatelessWidget {
  const Dialogouser({Key? key}) : super(key: key);

  static Future<bool> mostrarDialogo(BuildContext context) async {
    bool oyente = false;
    bool cerrar = false;

    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Identificate'),
        content: SingleChildScrollView(
            child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Usuario',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Contraseña',
              ),
            ),
          ],
        )),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              cerrar = true;
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              oyente = true;
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );

    while (oyente == false) {
      await Future.delayed(Duration(seconds: 2));
      print("funcionando dialogo");
      if (cerrar == true) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => mostrarDialogo(context),
      child: const Text('Show Dialog'),
    );
  }
}
