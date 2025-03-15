import 'package:firebase_database/firebase_database.dart';
import '../models/message.dart';

class FirebaseService {
  // Obtén una referencia a la base de datos usando `ref()`
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('messages');

  // Enviar un mensaje
  void sendMessage(Message message) {
    _databaseRef.push().set(message.toMap());
  }

  // Obtener mensajes en tiempo real
  Stream<List<Message>> getMessages() {
    return _databaseRef.onValue.map((event) {
      final List<Message> messages = [];
      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          messages.add(Message.fromMap(value)..id = key); // Asignar el ID del mensaje
        });
      }
      messages.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Ordenar por timestamp
      return messages;
    });
  }

  // Método para eliminar un mensaje
  void deleteMessage(Message message) {
    if (message.id != null) {
      _databaseRef.child(message.id!).remove(); // Eliminar el mensaje usando su ID
    }
  }
}