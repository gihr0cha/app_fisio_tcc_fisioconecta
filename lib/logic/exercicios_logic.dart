import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ExerciciosLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  String getUserName() {
    final user = _auth.currentUser;
    return (user?.displayName ?? '').split(' ')[0];
  }

  Stream<DatabaseEvent> getExerciciosStream() {
    return _database.ref('exercicios').onValue;
  }

  Map<String, dynamic> formatDatabaseSnapshot(Map<dynamic, dynamic> map) {
    Map<String, dynamic> formattedMap = {};
    map.forEach((key, value) {
      formattedMap[key.toString()] = value;
    });
    return formattedMap;
  }

  List<dynamic> filterExercicios(Map<String, dynamic> exercicios, String filter) {
    return exercicios.values
        .where((exercicio) =>
            exercicio.toString().toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  void deleteExercicio(String key) {
    _database.ref('exercicios/$key').remove();
  }
}
