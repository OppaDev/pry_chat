import 'package:firebase_database/firebase_database.dart';
import '../models/mensaje.dart';

class FirebaseService {
  final _db = FirebaseDatabase.instance.ref();

  Stream<List<Mensaje>> recibirMensajes(String chatId) {
    return _db.child('messages/$chatId').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries
          .map((e) => Mensaje.fromJson(e.key, Map<String, dynamic>.from(e.value)))
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    });
  }

  Future<void> enviarMensaje(String chatId, String texto, String autor) async {
    final mensaje = Mensaje(
      texto: texto,
      autor: autor,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    await _db.child('messages/$chatId').push().set(mensaje.toJson());
  }

  Future<void> actualizarMensaje(String chatId, String mensajeId, String nuevoTexto) async {
    await _db.child('messages/$chatId/$mensajeId').update({
      'texto': nuevoTexto,
      'editado': true,
    });
  }

  Future<void> eliminarMensaje(String chatId, String mensajeId) async {
    await _db.child('messages/$chatId/$mensajeId').remove();
  }

  // ========== FUNCIONALIDAD "ESTÁ ESCRIBIENDO" ==========
  
  /// Establecer el estado de escritura de un usuario
  Future<void> setTypingStatus(String chatId, String userName, bool isTyping) async {
    try {
      await _db.child('typing_status/$chatId/$userName').set({
        'isTyping': isTyping,
        'timestamp': ServerValue.timestamp,
      });
    } catch (e) {
      print('Error setting typing status: $e');
    }
  }

  /// Escuchar los estados de escritura de todos los usuarios
  Stream<Map<String, bool>> getTypingStatus(String chatId) {
    return _db.child('typing_status/$chatId').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <String, bool>{};
      
      final Map<String, bool> typingUsers = {};
      final now = DateTime.now().millisecondsSinceEpoch;
      
      data.forEach((user, status) {
        if (status is Map<dynamic, dynamic>) {
          final isTyping = status['isTyping'] as bool? ?? false;
          final timestamp = status['timestamp'] as int? ?? 0;
          
          // Solo considerar como "escribiendo" si es reciente (últimos 4 segundos)
          // y el estado es true
          if (now - timestamp < 4000 && isTyping) {
            typingUsers[user] = true;
          }
        }
      });
      
      return typingUsers;
    });
  }

  /// Limpiar el estado de escritura de un usuario (al salir del chat)
  Future<void> clearTypingStatus(String chatId, String userName) async {
    try {
      await _db.child('typing_status/$chatId/$userName').remove();
    } catch (e) {
      print('Error clearing typing status: $e');
    }
  }

  /// Limpiar estados de escritura expirados (opcional, para limpieza automática)
  Future<void> cleanupExpiredTypingStatus(String chatId) async {
    try {
      final snapshot = await _db.child('typing_status/$chatId').get();
      if (!snapshot.exists) return;
      
      final data = snapshot.value as Map<dynamic, dynamic>;
      final now = DateTime.now().millisecondsSinceEpoch;
      
      data.forEach((user, status) async {
        if (status is Map<dynamic, dynamic>) {
          final timestamp = status['timestamp'] as int? ?? 0;
          // Eliminar estados más antiguos a 10 segundos
          if (now - timestamp > 10000) {
            await _db.child('typing_status/$chatId/$user').remove();
          }
        }
      });
    } catch (e) {
      print('Error cleaning up typing status: $e');
    }
  }
}
