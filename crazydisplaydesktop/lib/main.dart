import 'dart:io';
import 'dart:math';

import 'package:crazydisplaydesktop/Dialogouser.dart';
import 'package:crazydisplaydesktop/Utils.dart';
import 'package:crazydisplaydesktop/Lista.dart';
import 'package:crazydisplaydesktop/Appdata.dart';
import 'package:crazydisplaydesktop/Loading.dart';
import 'package:crazydisplaydesktop/mensaje.dart';
import 'package:file_picker/file_picker.dart';
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
  String? imagePath;
  static String userpass = "";

  final TextEditingController ipController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool conectado = false;
  bool usuariocorrecto = false;
  bool imagencargada = false;

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

  static void userpassadd(String newuser) {
    userpass = newuser;
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
        width: 700,
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
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                ElevatedButton(
                  onPressed: imagencargada ? () {} : null,
                  child: Text('Send image'),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                ElevatedButton(
                  onPressed: conectado
                      ? () async {
                          FilePickerResult? result = await openFilePicker();
                          if (result != null) {
                            setState(() {
                              imagePath = result.files.single.path!;
                              conectado = true;
                            });
                          }
                          print(imagePath);
                        }
                      : null,
                  child: Text('Upload'),
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
      if (message == "Connected" && userpass == "") {
        LoadingOverlay.hide(context);
        userpass = (await MyDialog.mostrarDialogo(context))!;
        channel.sink.add(userpass);
      }
      print(message);
      
      if (message == "OK") {
        usuariocorrecto = true;
        channel.sink.add("Fluutter");
        setState(() {
          conectado = true;
        });
      }else if(message == "NOTOK"){
        disconnectToServer(ip, port);
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
    userpass = "";
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
      channel.sink.add(mensajeobject.toString());
      print(mensajeobject.toString());
      setState(() {
        conectado = true;
      });
    } else if (!checkmensajesrepetidos(mensaje)) {
      print("El mensaje no puede ser repetido");
    } else if (mensaje == "") {
      print("No es posible enviar mensajes vacios.");
    }
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
