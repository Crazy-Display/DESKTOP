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


