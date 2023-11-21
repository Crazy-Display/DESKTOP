
import 'dart:io';

import 'package:file_picker/file_picker.dart';

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
  
   Future<FilePickerResult?> openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    return result;
  }