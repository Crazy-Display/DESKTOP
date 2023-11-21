class Formulario{
  DateTime horaEnvio;
  String texto;
  String type;

  Formulario({
    required this.horaEnvio,
    required this.texto,
    required this.type,
  });

  //metodo que transforma un map a un objeto Mensaje
  factory Formulario.fromJson(Map<String, dynamic> json) {
    return Formulario(
      horaEnvio: DateTime.parse(json['horaEnvio']),
      texto: json['texto'],
      type: json['type']
    );
  }

  // Método para convertir el objeto a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'horaEnvio': horaEnvio.toIso8601String(),
      'texto': texto,
      'type': type,
    };
  }
}


