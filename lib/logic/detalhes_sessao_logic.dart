import 'package:firebase_database/firebase_database.dart';

class DetalhesSessaoLogic {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  /// Obtém o stream dos dados da sessão com base na chave
  Stream<DatabaseEvent> getSessaoStream(String sessaoKey) {
    return _database.ref().child('sessoes').child(sessaoKey).onValue;
  }

  /// Converte o snapshot do Firebase para um mapa utilizável
  Map<String, dynamic> parseSnapshot(DatabaseEvent snapshot) {
    return Map<String, dynamic>.from(snapshot.snapshot.value as Map);
  }
}
