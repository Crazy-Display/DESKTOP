import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crazy Display',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Crazy Display'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> condes = ["Connect", "Disconnect"];
  String actualtextconnect = "Connect";
  String ipserver = "";
  String messagetextform = "";
  String iptextform = "";
  String port = "8888";
  String _miVariableTexto = "Disconnected!";

  final TextEditingController ipController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool conectado = false;

  void conectardesconectar() {
    if (conectado) {
      conectado = false;
    } else if (!conectado) {
      conectado = true;
    }
  }

  void actualizar_texto_connectar() {
    setState(() {
      if (conectado == true) {
        actualtextconnect = condes[1];
      } else if (conectado == false) {
        actualtextconnect = condes[0];
      }
    });
  }

  bool esDireccionIP(String cadena) {
    List<String> partes = cadena.split('.');

    if (partes.length != 4) {
      return false;
    }

    for (var parte in partes) {
      try {
        int valor = int.parse(parte);
        if (valor < 0 || valor > 255) {
          return false;
        }
      } catch (e) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: ipController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Set IP server',
              ),
            ),
            SizedBox(height: 20), // Espacio entre los TextFormFields
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Message',
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      ipserver = ipController.text;
                      if (esDireccionIP(ipserver)) {
                        if (!conectado) {
                          connectToServer(ipserver, port);
                        } else if (conectado) {}
                      }
                    },
                    child: conectado
                        ? Text(
                            "$actualtextconnect",
                            style: TextStyle(color: Colors.red),
                          )
                        : Text(
                            "$actualtextconnect",
                            style: TextStyle(color: Colors.green),
                          )),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Coloca aquí el código que se ejecutará cuando se presione el botón.
                  },
                  child: Text('Send'),
                )
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      )),
    );
  }

   void connectToServer(String ip, String port) async {
    try {
      final channel = IOWebSocketChannel.connect('ws://$ip:$port');
      channel.sink.add("Hola servidor");
      conectado = true;
      actualizar_texto_connectar();
      channel.stream.listen((message) {
        // Manejar mensajes recibidos del servidor
      }, onDone: () {
        // Manejar cuando la conexión se cierra
        setState(() {
          conectado = false;
          actualizar_texto_connectar();
        });
      }, onError: (error) {
        // Manejar errores de conexión
        print('Error de conexión: $error');
      });
    } catch (e) {
      print('Error al conectar al servidor: $e');
    }
    // Espera 5 segundos y verifica si la conexión se estableció
  }

  void disconnectToServer(String ip, String port) async {
    try {} catch (e) {}
  }
}
