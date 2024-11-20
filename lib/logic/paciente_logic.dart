import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PacienteLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  String getUserName() {
    final user = _auth.currentUser;
    return (user?.displayName ?? '').split(' ')[0];
  }

  String? getFisioId() {
    return _auth.currentUser?.uid;
  }

  Stream<DatabaseEvent> getPacientesStream() {
    return _database.ref().child('pacientes').onValue;
  }

  Map<String, dynamic> formatDatabaseSnapshot(Map<dynamic, dynamic> map) {
    Map<String, dynamic> formattedMap = {};
    map.forEach((key, value) {
      formattedMap[key.toString()] = value;
    });
    return formattedMap;
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