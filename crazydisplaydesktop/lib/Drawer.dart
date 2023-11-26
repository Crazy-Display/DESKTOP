import 'package:crazydisplaydesktop/LayoutGaleriaempty.dart';
import 'package:crazydisplaydesktop/Layoutgaleria.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'Appdata.dart';
import 'Layoutlistausuario.dart';

class MyDrawer extends StatefulWidget {
  final bool connected;
  final IOWebSocketChannel channel;
  List<String> usernames;

  // Constructor que recibe el booleano
  MyDrawer(
      {required this.connected,
      required this.channel,
      required this.usernames});

  @override
  _MyDrawerState createState() => _MyDrawerState(
      connected: connected, channel: channel, usernames: usernames);
}

class _MyDrawerState extends State<MyDrawer> {
  final bool connected;
  final IOWebSocketChannel channel;
  final List<String> usernames;

  _MyDrawerState(
      {required this.connected,
      required this.channel,
      required this.usernames});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 60,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple[200],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Crazy menu'),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(8.0),
            ),
          ),
          ListTile(
            title: Text('Show server users'),
            onTap: widget.connected
                ? () {
                  mostrarListaEnDialog(context, usernames);
                  }
                : null,
          ),
          ListTile(
            title: const Text('Current images'),
            onTap: () {
              String textf = "";
              List<String> imagenes = recogernombresdelasfotos();
              if (imagenes.isEmpty || connected == false) {
                if (imagenes.isEmpty) {
                  textf = "Gallery is empty";
                }
                if (!connected) {
                  textf = "Connect to see gallery";
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LayoutGaleriaemptyordisc(text: textf),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LayoutGaleria(
                      imagenes: imagenes,
                      channel: channel,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
