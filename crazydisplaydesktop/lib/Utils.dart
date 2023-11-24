import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

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

String imageToBase64(String imagePath) {
  File imageFile = File(imagePath);
  List<int> imageBytes = imageFile.readAsBytesSync();
  String base64Image = base64Encode(imageBytes);
  return base64Image;
}

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration:
          Duration(seconds: 3), // Ajusta la duración según tus necesidades
    ),
  );
}
