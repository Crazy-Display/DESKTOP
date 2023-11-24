import 'dart:convert';
import 'dart:io';

import 'package:crazydisplaydesktop/mensaje.dart';

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

List<String> recogernombresdelasfotos(){
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
      lista.add(path);
    }
  } catch (e) {
    // Maneja cualquier error que pueda ocurrir al leer el archivo
    print('Error al leer el archivo: $e');
  }
  return lista;
}

void subirimagenajson(String imgpath) {
  // Ruta del archivo JSON
  String filePath = 'data/assets/images/imagenes.json';

  try {
    // Lee el contenido actual del archivo
    String jsonString = File(filePath).readAsStringSync();

    // Decodifica el contenido del JSON a una lista de objetos
    List<dynamic> jsonList = jsonDecode(jsonString);

    // Añade un nuevo objeto a la lista
    jsonList.add({"path": imgpath});

    // Codifica la lista a formato JSON
    String nuevoJsonString = jsonEncode(jsonList);

    // Escribe el nuevo contenido de vuelta al archivo
    File(filePath).writeAsStringSync(nuevoJsonString);

    print('Imagen añadida con éxito al archivo JSON.');

  } catch (e) {
    // Maneja cualquier error que pueda ocurrir al leer o escribir el archivo
    print('Error al manipular el archivo JSON: $e');
  }
}