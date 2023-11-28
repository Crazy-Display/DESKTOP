import 'dart:convert';
import 'dart:io';

import 'package:crazydisplaydesktop/mensaje.dart';
import 'package:flutter/material.dart';
import 'Utils.dart';

Future<List<Map<String, dynamic>>> cargarDatosDesdeArchivo(
    String archivoJSONPath) async {
  final archivo = File(archivoJSONPath);

  if (await archivo.exists()) {
    final contenido = await archivo.readAsString();
    final List<dynamic> datos = jsonDecode(contenido);
    return datos.cast<Map<String, dynamic>>();
  } else {
    return [];
  }
}

Future<void> agregarDatosAlArchivo(
    Map<String, dynamic> nuevosDatos, String archivoJSONPath) async {
  final archivo = File(archivoJSONPath);
  List<Map<String, dynamic>> datos =
      await cargarDatosDesdeArchivo(archivoJSONPath);
  datos.add(nuevosDatos);
  await archivo.writeAsString(jsonEncode(datos));
}

Future<List<Mensaje>> recuperarpersistencia(String archivoJSONPath) async {
  List<Mensaje> newlista = [];
  List<Map<String, dynamic>> json =
      await cargarDatosDesdeArchivo(archivoJSONPath);
  for (var i = 0; i < json.length; i++) {
    newlista.add(Mensaje.fromJson(json[i]));
  }
  return newlista;
}

List<String> recogernombresdelasfotos() {
  List<String> lista = [];
  List<String> listafiltrada = [];

  String filePath = 'data/assets/images/imagenes.json';

  try {
    // Intenta leer el contenido del archivo
    String jsonString = File(filePath).readAsStringSync();
    // Decodifica el JSON a una lista de cadenas
    List<dynamic> jsonList = jsonDecode(jsonString);
    // Itera sobre los elementos JSON y agrega las rutas a la lista
    for (dynamic element in jsonList) {
      String path = element['path'];
      if (File(path).existsSync()) {
        lista.add(path);
        listafiltrada.add(element['path'].toString());
      }
    }

    // Convierte la lista a una lista de mapas con la propiedad 'path'
    List<Map<String, String>> nuevaLista =
        listafiltrada.map((path) => {"path": path}).toList();
    // Convierte la lista de mapas a una cadena JSON
    String nuevoJsonString = jsonEncode(nuevaLista);
    // Escribe el nuevo JSON en el archivo
    File(filePath).writeAsStringSync(nuevoJsonString);
  } catch (e) {
    // Maneja cualquier error que pueda ocurrir al leer el archivo
    print('Error al leer el archivo: $e');
  }
  return lista;
}

void subirimagenajson(BuildContext context, String imgpath) {
  String filePath = 'data/assets/images/imagenes.json';

  try {
    String jsonString = File(filePath).readAsStringSync();

    List<dynamic> jsonList = jsonDecode(jsonString);

    for (var element in jsonList) {
      if (imgpath == element["path"].toString()) {
        showSnackbar(context, "The image $imgpath it has already been added.");
        return;
      }
    }
    jsonList.add({"path": imgpath});

    String nuevoJsonString = jsonEncode(jsonList);

    File(filePath).writeAsStringSync(nuevoJsonString);

    showSnackbar(context, "$imgpath add to gallery! is the current image!");
  } catch (e) {
    print('Error al manipular el archivo JSON: $e');
  }
}

void eliminarimagen(BuildContext context, String imgpath) {
  List<String> lista = [];

  String filePath = 'data/assets/images/imagenes.json';

  try {
    // Intenta leer el contenido del archivo
    String jsonString = File(filePath).readAsStringSync();
    // Decodifica el JSON a una lista de cadenas
    List<dynamic> jsonList = jsonDecode(jsonString);
    // Itera sobre los elementos JSON y agrega las rutas a la lista
    for (dynamic element in jsonList) {
      String path = element['path'];
      if (imgpath != path) {
        lista.add(element["path"].toString());
      }
    }

    // Convierte la lista a una lista de mapas con la propiedad 'path'
    List<Map<String, String>> nuevaLista =
        lista.map((path) => {"path": path}).toList();
    // Convierte la lista de mapas a una cadena JSON
    String nuevoJsonString = jsonEncode(nuevaLista);
    // Escribe el nuevo JSON en el archivo
    File(filePath).writeAsStringSync(nuevoJsonString);
  } catch (e) {
    // Maneja cualquier error que pueda ocurrir al leer el archivo
    print('Error al leer el archivo: $e');
  }
}
