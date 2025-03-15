class Message {
  final String sender;
  final String text;
  final int timestamp;
  final String? imageUrl; // Nuevo campo para la URL de la imagen
  final Message? replyTo; // Nuevo campo para el mensaje al que se está respondiendo
  String? id; // Nuevo campo para el ID del mensaje

  Message({
    required this.sender,
    required this.text,
    required this.timestamp,
    this.imageUrl, // Incluir el campo en el constructor
    this.replyTo, // Incluir el campo en el constructor
    this.id, // Incluir el ID en el constructor
  });

  // Método toMap actualizado
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': timestamp,
      'imageUrl': imageUrl, // Incluir la URL de la imagen en el mapa
      'replyTo': replyTo?.toMap(), // Incluir el mensaje al que se está respondiendo
    };
  }

  // Método fromMap actualizado
  factory Message.fromMap(Map<dynamic, dynamic> map) {
    return Message(
      sender: map['sender'],
      text: map['text'],
      timestamp: map['timestamp'],
      imageUrl: map['imageUrl'], // Mapear la URL de la imagen
      replyTo: map['replyTo'] != null ? Message.fromMap(map['replyTo']) : null, // Mapear el mensaje al que se está respondiendo
    );
  }
}