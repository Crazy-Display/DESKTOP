import 'package:crazydisplaydesktop/Appdata.dart';
import 'package:crazydisplaydesktop/mensaje.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            margin: EdgeInsets.all(3),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color.fromARGB(255, 205, 176, 255),
              boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: Offset(2, 2),
                ),]
            ),
                child: Stack(
                  children: [
                    Text(mensajes[mensajes.length-index-1].texto),
                    Positioned(
                      right: 0,
                      child: Text(returnhoraminuto(mensajes[mensajes.length-index-1].horaEnvio),style: TextStyle(fontStyle: FontStyle.italic,color: Colors.deepPurple[500],fontSize: 12),))
                  ],
                ));
        });
  }
}

String returnhoraminuto(DateTime now){
  String formattedTime = DateFormat('HH:mm').format(now);
  return formattedTime;
}
