class Mensaje {
  final String? id;
  final String texto;
  final String autor;
  final int timestamp;
  final bool editado;

  Mensaje({
    this.id,
    required this.texto, 
    required this.autor, 
    required this.timestamp,
    this.editado = false,
  });

  factory Mensaje.fromJson(String key, Map<dynamic, dynamic> json) => Mensaje(
    id: key,
    texto: json['texto'],
    autor: json['autor'],
    timestamp: json['timestamp'],
    editado: json['editado'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'texto': texto,
    'autor': autor,
    'timestamp': timestamp,
    'editado': editado,
  };
}
