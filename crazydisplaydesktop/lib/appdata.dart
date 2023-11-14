import 'dart:convert';
import 'dart:io';

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

Future<void> agregarDatosAlArchivo(Map<String, dynamic> nuevosDatos,String archivoJSONPath) async {
    final archivo = File(archivoJSONPath);
    List<Map<String, dynamic>> datos = await cargarDatosDesdeArchivo(archivoJSONPath);
    datos.add(nuevosDatos);
    await archivo.writeAsString(jsonEncode(datos));
  }
