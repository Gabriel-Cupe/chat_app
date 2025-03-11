import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/message.dart';
import '../firebase_options.dart'; // Importa la configuración de Firebase

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("messages");

  // Método para inicializar Firebase antes de usarlo
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void sendMessage(Message message) {
    _dbRef.push().set(message.toJson());
  }

  Stream<List<Message>> getMessages() {
    return _dbRef.orderByChild("timestamp").onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return [];

      return data.values.map((value) {
        return Message.fromJson(Map<String, dynamic>.from(value));
      }).toList().reversed.toList();
    });
  }
}
