import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'appdata.dart';

class LayoutGaleria extends StatefulWidget {
  List<String> imagenes;

  LayoutGaleria({required this.imagenes});

  @override
  _LayoutGaleriaState createState() => _LayoutGaleriaState();
}

class _LayoutGaleriaState extends State<LayoutGaleria> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crazy gallery'),
      ),
      // Utiliza RefreshIndicator para envolver el GridView
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshPage,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: widget.imagenes.length,
          itemBuilder: (context, index) {
            return _buildImageItem(widget.imagenes[index]);
          },
        ),
      ),
    );
  }

  Widget _buildImageItem(String imagePath) {
    return InkWell(
      onTap: () {
        _showOptions(context, imagePath);
      },
      child: Image.file(File(imagePath)),
    );
  }

  void _showOptions(BuildContext context, String imagePath) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.send),
                title: Text('Send'),
                onTap: () {
                  // Implementa la lógica de editar aquí
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  // Implementa la lógica de eliminar aquí
                  eliminarimagen(context, imagePath);
                  _refreshPage();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _refreshPage() async {
    // Puedes realizar cualquier tarea de recarga necesaria aquí
    // Por ejemplo, puedes actualizar la lista de imágenes llamando a setState
    setState(() {
      widget.imagenes = recogernombresdelasfotos();
    });
  }
}
