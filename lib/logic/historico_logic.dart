import 'utils.dart';
import 'package:firebase_database/firebase_database.dart';


class HistoricoLogic {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  String getUserName() {
    return FirebaseUtils.getUserName();
  }

  /// Retorna o stream das sessões do Firebase Realtime Database
  Stream<DatabaseEvent> getSessoesStream() {
    return _database.ref().child('sessoes').onValue;
  }

  /// Formata os dados do snapshot do Firebase para um mapa utilizável
Map<String, dynamic> formatDatabaseSnapshot(Map<dynamic, dynamic> map) {
    return FirebaseUtils.formatDatabaseSnapshot(map);
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
