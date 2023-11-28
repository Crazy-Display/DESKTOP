class Mensaje {
  int Id;
  String ip;
  DateTime horaEnvio;
  String texto;
  String type;

  Mensaje({
    required this.Id,
    required this.ip,
    required this.horaEnvio,
    required this.texto,
    required this.type,
  });

  //metodo que transforma un map a un objeto Mensaje
  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
        Id: json['Id'],
        ip: json['ip'],
        horaEnvio: DateTime.parse(json['horaEnvio']),
        texto: json['texto'],
        type: json['type']);
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

  @override
  String toString() {
    return "{\"Id\":\"$Id\",\"ip\":\"$ip\",\"horaEnvio\":\"$horaEnvio\",\"texto\":\"$texto\",\"type\":\"$type\"}";
  }
}
