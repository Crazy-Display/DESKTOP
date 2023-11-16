import 'package:flutter/material.dart';

class Dialogouser extends StatelessWidget {
  
  const Dialogouser({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Identificate'),
          actions: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Usuario',
              ),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}
