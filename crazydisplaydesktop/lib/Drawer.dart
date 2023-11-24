import 'package:crazydisplaydesktop/Layoutgaleria.dart';
import 'package:flutter/material.dart';
import 'Appdata.dart';

class MyDrawer extends StatefulWidget {
  final bool connected;

  // Constructor que recibe el booleano
  MyDrawer({required this.connected});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
            onTap: widget.connected
                ? () {
                    // Acción al seleccionar la opción 1 cuando está habilitada
                  }
                : null, // Desactiva la opción cuando no está habilitada
          ),
          ListTile(
            title: const Text('Current images'),
            onTap: () {
              List<String> imagenes = recogernombresdelasfotos();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LayoutGaleria(imagePaths: imagenes),
                ),
              );
              // Acción al seleccionar la opción 2
            },
          ),
        ],
      ),
    );
  }
}
