import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ExerciciosLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  String getUserName() {
    // é possível reutilizar essa função em outras classes sem precisar reescrever
    final user = _auth.currentUser;
    return (user?.displayName ?? '').split(' ')[0];
  }

  Stream<DatabaseEvent> getExerciciosStream() {
    // utiliza o mesmo método de obter os dados do banco de dados, podendo ser reutilizado em outras classes
    return _database.ref('exercicios').onValue;
  }

  Map<String, dynamic> formatDatabaseSnapshot(Map<dynamic, dynamic> map) {
    // formata o snapshot do banco de dados para um mapa de strings e dinâmicos
    Map<String, dynamic> formattedMap = {};
    map.forEach((key, value) {
      formattedMap[key.toString()] = value;
    });
    return formattedMap;
  }

  List<dynamic> filterExercicios(Map<String, dynamic> exercicios, String filter) {
    // filtra os exercícios a partir de um filtro passado como parâmetro e retorna uma lista
    return exercicios.values
        .where((exercicio) =>
            exercicio.toString().toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  void deleteExercicio(String key) {
    _database.ref('exercicios/$key').remove();
  }
}
