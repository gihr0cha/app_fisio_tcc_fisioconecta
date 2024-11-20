import 'package:firebase_database/firebase_database.dart';
import 'firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PacienteLogic {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

 String getUserName() {
    return FirebaseUtils.getUserName();
  }

  String? getFisioId() {
    return _auth.currentUser?.uid;
  }

  Stream<DatabaseEvent> getPacientesStream() {
    return _database.ref().child('pacientes').onValue;
  }

  Map<String, dynamic> formatDatabaseSnapshot(Map<dynamic, dynamic> map) {
    return FirebaseUtils.formatDatabaseSnapshot(map);
  }

  List<dynamic> filterPacientes(
      Map<String, dynamic> pacientes, String filter, String? fisioId) {
    return pacientes.values
        .where((patient) =>
            patient['nome']
                .toString()
                .toLowerCase()
                .contains(filter.toLowerCase()) &&
            patient['fisioId'] == fisioId)
        .toList();
  }
}