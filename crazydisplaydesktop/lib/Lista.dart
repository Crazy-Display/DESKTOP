import 'package:crazydisplaydesktop/mensaje.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';
import 'Main.dart';

class Lista extends StatefulWidget {
  final List<Mensaje> mensajes;
  final IOWebSocketChannel channel;

  const Lista({super.key, required this.mensajes, required this.channel});
  @override
  State<StatefulWidget> createState() =>
      _Lista(mensajes: mensajes, channel: channel);
}

class _Lista extends State<Lista> {
  String archivoJSONPath = 'data/assets/mensajes.json';

  final IOWebSocketChannel channel;
  final List<Mensaje> mensajes;
  final List<int> colorCodes = <int>[600, 500, 100];
  Mensaje? selectedMenu;

  _Lista({required this.mensajes, required this.channel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: mensajes.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              margin: EdgeInsets.all(3),
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color.fromARGB(255, 205, 176, 255),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(2, 2),
                    ),
                  ]),
              child: Stack(
                children: [
                  PopupMenuButton<Mensaje>(
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<Mensaje>>[
                      PopupMenuItem<Mensaje>(
                        value: mensajes[mensajes.length - index - 1],
                        child: Text('Reenviar'),
                      ),
                    ],
                    onSelected: (Mensaje item) {

                      channel.sink.add(mensajes[mensajes.length - index - 1].toString());
                      

                    },
                  ),
                  Positioned(
                    left: 50,
                    top: 9,
                    child: Text(mensajes[mensajes.length - index - 1].texto),
                  ),
                  Positioned(
                      bottom: 5,
                      right: 5,
                      child: Text(
                        returnhoraminuto(
                            mensajes[mensajes.length - index - 1].horaEnvio),
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.deepPurple[500],
                            fontSize: 12),
                      ))
                ],
              ));
        });
  }
}

String returnhoraminuto(DateTime now) {
  String formattedTime = DateFormat('HH:mm').format(now);
  return formattedTime;
}
