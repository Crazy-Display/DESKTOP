import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:crazydisplaydesktop/mensaje.dart';
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
  IOWebSocketChannel? channel;

  List<String> condes = ["Connect", "Disconnect"];
  List<Mensaje> mensajes = [];

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
                    onPressed: () async {
                      ipserver = ipController.text;
                      if (esDireccionIP(ipserver)) {
                        if (!conectado) {
                          connectToServer(ipserver, port);
                        } else if (conectado) {
                          disconnectToServer(ipserver, port);
                        }
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
                  onPressed: conectado
                      ? () {
                          enviarmensajeyguardararray();
                        }
                      : null,
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
    channel = IOWebSocketChannel.connect('ws://$ip:$port');
    channel?.sink.add("Hola servidor");
    conectado = true;
    actualizar_texto_connectar();
    channel?.stream.listen((message) {
      // Manejar mensajes recibidos del servidor
    }, onDone: () {
      // Manejar cuando la conexión se cierra
      conectado = false;
      setState(() {
        actualizar_texto_connectar();
      });
    }, onError: (error) {
      // Manejar errores de conexión
      print('Error de conexión: $error');
    });
    // Espera 5 segundos y verifica si la conexión se estableció
  }

  void disconnectToServer(String ip, String port) async {
    channel?.sink.close();
  }

  Future<void> enviarmensajeyguardararray() async {
    String mensaje = messageController.text;
    if (checkmensajesrepetidos(mensaje)) {
      channel?.sink.add(mensaje);
      messageController.clear();
      String miip = await obtenerDireccionIPLocal();
      print(miip);
      Mensaje mensajeobject = new Mensaje(
          Id: idrandom(),
          ip: miip.toString(),
          horaEnvio: DateTime.now(),
          texto: mensaje);
      mensajes.add(mensajeobject);
      await agregarDatosAlArchivo(mensajeobject.toJson());
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

  static const String archivoJSONPath = 'data/assets/mensajes.json';

  Future<void> agregarDatosAlArchivo(Map<String, dynamic> nuevosDatos) async {
    final archivo = File(archivoJSONPath);
    List<Map<String, dynamic>> datos = await cargarDatosDesdeArchivo();
    datos.add(nuevosDatos);
    await archivo.writeAsString(jsonEncode(datos));
  }

  Future<List<Map<String, dynamic>>> cargarDatosDesdeArchivo() async {
    final archivo = File(archivoJSONPath);

    if (await archivo.exists()) {
      final contenido = await archivo.readAsString();
      final List<dynamic> datos = jsonDecode(contenido);
      return datos.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
  }

  int idrandom() {
    Random r = new Random();
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
