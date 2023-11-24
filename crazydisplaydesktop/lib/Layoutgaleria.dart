import 'dart:io';

import 'package:flutter/material.dart';

class LayoutGaleria extends StatefulWidget {
  final List<String> imagePaths;

  LayoutGaleria({required this.imagePaths});

  @override
  _LayoutGaleriaState createState() => _LayoutGaleriaState();
}

class _LayoutGaleriaState extends State<LayoutGaleria> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crazy gallery'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Número de columnas en el grid
          crossAxisSpacing: 4.0, // Espaciado horizontal entre elementos
          mainAxisSpacing: 4.0, // Espaciado vertical entre elementos
        ),
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) {
          return _buildImageItem(widget.imagePaths[index]);
        },
      ),
    );
  }

  Widget _buildImageItem(String imagePath) {
    return Image.file(File(imagePath));
  }
}
