import 'package:crazydisplaydesktop/LayoutGaleriaempty.dart';
import 'package:crazydisplaydesktop/Layoutgaleria.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'Appdata.dart';

class MyDrawer extends StatefulWidget {
  final bool connected;
  final IOWebSocketChannel channel;

  // Constructor que recibe el booleano
  MyDrawer({required this.connected, required this.channel});

  @override
  _MyDrawerState createState() =>
      _MyDrawerState(connected: connected, channel: channel);
}

class _MyDrawerState extends State<MyDrawer> {
  final bool connected;
  final IOWebSocketChannel channel;

  _MyDrawerState({required this.connected, required this.channel});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 40,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple.shade200,
              ),
              child: Text('Crazy menu'),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(8.0),
            ),
          ),
          ListTile(
            title: Text('Show server users'),
            onTap: widget.connected ? () {} : null,
          ),
          ListTile(
              title: const Text('Current images'),
              onTap: () {
                channel.sink.add("data");
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
                        builder: (context) =>
                            LayoutGaleriaemptyordisc(text: textf),
                      ));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LayoutGaleria(
                              imagenes: imagenes,
                              channel: channel,
                            )),
                  );
                }
              }),
        ],
      ),
    );
  }
}
