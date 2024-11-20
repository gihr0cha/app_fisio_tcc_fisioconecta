import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HistoricoLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  /// Obtém o nome do fisioterapeuta logado
  String getUserName() {
    // essa funçao ja esta escrita em outras classes. Poderia ser criada uma classe comum para reutilizar essa função
    final user = _auth.currentUser;
    return (user?.displayName ?? '').split(' ')[0];
  }

  /// Retorna o stream das sessões do Firebase Realtime Database
  Stream<DatabaseEvent> getSessoesStream() {
    return _database.ref().child('sessoes').onValue;
  }

  /// Formata os dados do snapshot do Firebase para um mapa utilizável
  Map<String, dynamic> formatDatabaseSnapshot(Map<dynamic, dynamic> map) {
    Map<String, dynamic> formattedMap = {};
    map.forEach((key, value) {
      formattedMap[key.toString()] = value;
    });
    return formattedMap;
  }

  /// Filtra as sessões pelo nome do paciente
  List<MapEntry<String, dynamic>> filterSessoes(
      Map<String, dynamic> sessoes, String filter) {
    return sessoes.entries
        .where((entry) =>
            entry.key.toString().toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }
}
