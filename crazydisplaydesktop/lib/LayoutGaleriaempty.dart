import 'package:flutter/material.dart';

class LayoutGaleriaemptyordisc extends StatelessWidget {
  const LayoutGaleriaemptyordisc({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crazy gallery'),
      ),
      body: Center(child: Text("$text")),
    );
  }
}
