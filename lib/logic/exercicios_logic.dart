import 'package:firebase_database/firebase_database.dart';
import '../utils.dart';

class ExerciciosLogic {

 final FirebaseDatabase _database = FirebaseDatabase.instance;
  String getUserName() {
    return FirebaseUtils.getUserName();
  }
  Stream<DatabaseEvent> getExerciciosStream() {
    // utiliza o mesmo método de obter os dados do banco de dados, podendo ser reutilizado em outras classes
    return _database.ref('exercicios').onValue;
  }

  Map<String, dynamic> formatDatabaseSnapshot(Map<dynamic, dynamic> map) {
    return FirebaseUtils.formatDatabaseSnapshot(map);
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
