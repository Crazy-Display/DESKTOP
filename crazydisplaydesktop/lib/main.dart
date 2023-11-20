import 'dart:io';
import 'dart:math';

import 'package:crazydisplaydesktop/Dialogouser.dart';

import 'lib/Dialogouser.dart';
import 'package:crazydisplaydesktop/Lista.dart';
import 'package:crazydisplaydesktop/Appdata.dart';
import 'package:crazydisplaydesktop/Loading.dart';
import 'package:crazydisplaydesktop/mensaje.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

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
  late IOWebSocketChannel channel;

  List<String> condes = ["Connect", "Disconnect"];
  List<Mensaje> mensajes = [];

  String archivoJSONPath = 'data/assets/mensajes.json';
  String actualtextconnect = "Connect";
  String ipserver = "";
  String messagetextform = "";
  String iptextform = "";
  String port = "8888";

  final TextEditingController ipController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool conectado = false;
  bool usuariocorrecto = false;

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
        width: 600,
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
              controller: messageController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Message',
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                    onPressed: !conectado
                        ? () async {
                            print("marihuano");
                            ipserver = ipController.text;
                            if (esDireccionIP(ipserver)) {
                              if (!conectado) {
                                channel = await connectToServer(
                                    ipserver, port, context);
                                mensajes = await recuperarpersistencia(
                                    archivoJSONPath);
                              }
                            }
                          }
                        : null,
                    child: Text("Conectar")),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                ElevatedButton(
                  onPressed: conectado
                      ? () {
                          disconnectToServer(ipserver, port);
                        }
                      : null,
                  child: Text("Desconectar"),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: conectado
                      ? () {
                          enviarmensajeyguardararray();
                        }
                      : null,
                  child: Text('Send'),
                )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
                child: conectado
                    ? Container(
                        child: Lista(
                        mensajes: mensajes,
                        channel: channel,
                      ))
                    : Container()),
          ],
        ),
      )),
    );
  }
/* AQUI EMPIEZAN FUNCIONES QUE UTILIZAREMOS PARA EL CORRECTO DESARROLLO DE LA APLICACIÓN*/

  Future<IOWebSocketChannel> connectToServer(
      String ip, String port, BuildContext context) async {
    LoadingOverlay.show(context);
    channel = await IOWebSocketChannel.connect('ws://$ipserver:$port');
    channel.stream.listen((message) async {
      if (message == "connected") {
        LoadingOverlay.hide(context);
        usuariocorrecto = await Dialogouser.mostrarDialogo(context);
        if (usuariocorrecto) {
          channel.sink.add("flutter");
          setState(() {
            conectado = true;
          });
        } else if (!usuariocorrecto) {
          disconnectToServer(ip, port);
        }
      }
    }, onDone: () {
      // Manejar cu ando la conexión se cierra
      setState(() {
        conectado = false;
        actualizar_texto_connectar();
      });
    }, onError: (error) {
      // Manejar errores de conexión
      print('Error de conexión: $error');
      LoadingOverlay.hide(context);
    });
    return channel;
  }

  void disconnectToServer(String ip, String port) async {
    channel.sink.close();
  }

  Future<void> enviarmensajeyguardararray() async {
    String mensaje = messageController.text;
    if (checkmensajesrepetidos(mensaje) && mensaje != "") {
      messageController.clear();
      String miip = await obtenerDireccionIPLocal();
      int newid;
      if (mensajes.isEmpty) {
        Random r = Random();
        int? numeroAleatorio;
        numeroAleatorio = r.nextInt(901) + 100;
        newid = numeroAleatorio;
      } else {
        newid = idrandom();
      }
      Mensaje mensajeobject = Mensaje(
          Id: newid,
          ip: miip,
          horaEnvio: DateTime.now(),
          texto: mensaje,
          type: "texto");
      mensajes
          .add(mensajeobject); //agrego el objeto mensaje al array de mensajes
      await agregarDatosAlArchivo(mensajeobject.toJson(),
          archivoJSONPath); //guardo el mensaje como json
      channel.sink.add(mensajeobject.toJson().toString());
      setState(() {
        conectado = true;
      });
    } else if (!checkmensajesrepetidos(mensaje)) {
      print("El mensaje no puede ser repetido");
    } else if (mensaje == "") {
      print("No es posible enviar mensajes vacios.");
    }
  }

  Future<String> obtenerDireccionIPLocal() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          // Verifica si la dirección es IPv4 y no es la dirección loopback
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }
    } catch (e) {
      print('Error al obtener la dirección IP local: $e');
    }

    return 'No se pudo obtener la dirección IP local';
  }

  bool checkmensajesrepetidos(String mensaje) {
    for (var i = 0; i < mensajes.length; i++) {
      if (mensajes[i].texto == mensaje) {
        return false;
      }
    }
    return true;
  }

  int idrandom() {
    Random r = Random();
    int? numeroAleatorio;
    numeroAleatorio = r.nextInt(901) + 100;
    for (var i = 0; i < mensajes.length; i++) {
      if (mensajes[i].Id == numeroAleatorio) {
        return idrandom();
      }
    }
    return numeroAleatorio;
  }
}
