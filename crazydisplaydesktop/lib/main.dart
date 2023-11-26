import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crazydisplaydesktop/Dialogouser.dart';
import 'package:crazydisplaydesktop/Drawer.dart';
import 'package:crazydisplaydesktop/Utils.dart';
import 'package:crazydisplaydesktop/Lista.dart';
import 'package:crazydisplaydesktop/Appdata.dart';
import 'package:crazydisplaydesktop/Loading.dart';
import 'package:crazydisplaydesktop/mensaje.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/io.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

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
  List<String> usernames = [];

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

  void conectarDesconectar() {
    setState(() {
      conectado = !conectado;
      actualizarTextoConnectar();
    });
  }

  void actualizarTextoConnectar() {
    setState(() {
      actualtextconnect = conectado ? condes[1] : condes[0];
    });
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
      drawer: conectado
          ? MyDrawer(
              connected: conectado,
              channel: channel,
              usernames: usernames,
            )
          : null,
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
              enabled: conectado, // Habilitar cuando conectado es true
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
                          enviarmensajeyguardararray(context);
                        }
                      : null,
                  child: Text('Send'),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                ElevatedButton(
                  onPressed: imagencargada && conectado
                      ? () {
                          String imgbase = imageToBase64(imagePath!);
                          channel.sink.add(
                              "{\"type\":\"image\",\"code\":\"$imgbase\"}");
                          showSnackbar(context, "Sending image...");
                          setState(() {
                            imagencargada = false;
                          });
                        }
                      : null,
                  child: Text('Send current image'),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                ElevatedButton(
                  onPressed: conectado
                      ? () async {
                          XFile? imageFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (imageFile != null) {
                            imagePath = imageFile.path;
                            conectado = true;

                            // Convierte la ruta relativa a absoluta si es necesario
                            String absolutePath = join(Directory.current.path,
                                imagePath?.replaceAll('\\', '/'));

                            // Ahora puedes usar 'absolutePath' para abrir o manipular el archivo
                            subirimagenajson(context, absolutePath);
                            setState(() {
                              imagencargada = true;
                            });
                          }
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
      channel.sink.add("pong");
      try {
        // Intenta decodificar la cadena como JSON
        dynamic json = jsonDecode(message);
        if (json["type"] == "users") {
          usernames = [];
          for (var element in json["usersFlutter"]) {
            usernames.add(element + " - Flutter");
          }
          for (var element in json["usersApp"]) {
            usernames.add(element + " - App");
          }
          setState(() {
            usernames;
          });
        }

        // Si no se lanza una excepción, la cadena es un JSON válido
      } catch (e) {
        if (message == "Connected" && userpass == "") {
          LoadingOverlay.hide(context);
          userpass = (await MyDialog.mostrarDialogo(context))!;
          channel.sink.add(userpass);
        }
        print(message);

        if (message == "OK") {
          usuariocorrecto = true;
          channel.sink.add("Fluutter");
          showSnackbar(context, "Connected to server crazy display!");
          setState(() {
            conectado = true;
          });
        } else if (message == "NOTOK") {
          disconnectToServer(ip, port);
        }
      }
    }, onDone: () {
      // Manejar cu ando la conexión se cierra
      setState(() {
        conectado = false;
        actualizarTextoConnectar();
      });
    }, onError: (error) {
      // Manejar errores de conexión
      print('Error de conexión: $error');
      LoadingOverlay.hide(context);
      showSnackbar(context, "Connection could not be accessed.");
    });
    return channel;
  }

  void disconnectToServer(String ip, String port) async {
    channel.sink.close();
    userpass = "";
  }

  Future<void> enviarmensajeyguardararray(BuildContext context) async {
    String mensaje = messageController.text;
    if (checkmensajesrepetidos(mensaje, mensajes) && mensaje != "") {
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
      showSnackbar(context, "Sending...");
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        conectado = true;
      });
    } else if (!checkmensajesrepetidos(mensaje, mensajes)) {
      showSnackbar(context, "cannot repeat the message.");
    } else if (mensaje == "") {
      showSnackbar(context, "it is not possible to send an empty message.");
    }
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
