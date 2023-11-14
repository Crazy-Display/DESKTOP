class Mensaje {
  int Id;
  String ip;
  DateTime horaEnvio;
  String texto;

  Mensaje({
    required this.Id,
    required this.ip,
    required this.horaEnvio,
    required this.texto,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      Id: json['Id'],
      ip: json['ip'],
      horaEnvio: DateTime.parse(json['horaEnvio']),
      texto: json['texto'],
    );
  }

  // Método para convertir el objeto a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'ip': ip,
      'horaEnvio': horaEnvio.toIso8601String(),
      'texto': texto,
    };
  }
}


