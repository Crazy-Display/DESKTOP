import 'package:crazydisplaydesktop/appdata.dart';
import 'package:crazydisplaydesktop/mensaje.dart';
import 'package:flutter/material.dart';

class Lista extends StatefulWidget {
  final List<Mensaje> mensajes;

  const Lista({super.key, required this.mensajes});
  @override
  State<StatefulWidget> createState() => _Lista(mensajes: mensajes);
}

class _Lista extends State<Lista> {
  String archivoJSONPath = 'data/assets/mensajes.json';

  final List<Mensaje> mensajes;
  final List<int> colorCodes = <int>[600, 500, 100];

  _Lista({required this.mensajes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: mensajes.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color.fromARGB(255, 205, 176, 255),
            ),
            child: Center(
                child: Text(mensajes[mensajes.length - index - 1].texto)),
          );
        });
  }
}
