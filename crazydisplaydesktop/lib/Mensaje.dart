class Mensaje {
  int Id;
  String ip;
  DateTime horaEnvio;
  String texto;
  String type = "flutter";

  Mensaje({
    required this.Id,
    required this.ip,
    required this.horaEnvio,
    required this.texto,
  });

  //metodo que transforma un map a un objeto Mensaje
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
      'type': type,
    };
  }
}


