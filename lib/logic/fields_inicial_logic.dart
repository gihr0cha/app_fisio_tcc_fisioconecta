import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FieldsInicialLogic {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String customSessionKey;

  /// Gera uma chave personalizada para a sessão
  String generateSessionKey(Map<String, dynamic> paciente) {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}--${now.hour}:${now.minute}";
    customSessionKey = "${paciente['nome']}-$formattedDate";
    return customSessionKey;
  }

  /// Salva os dados iniciais da sessão no Firebase
  Future<void> saveInitialSession(
      Map<String, dynamic> paciente, List<Map<String, dynamic>> selectedFields) async {
    DatabaseReference sessionRef = _database.ref().child('sessoes').child(customSessionKey);

    List<String> initialData = selectedFields
        .map((field) => "${field['label']}: ${field['value']}")
        .toList();

    await sessionRef.set({
      'inicio_sessao': initialData,
    });
  }

  /// Valida o formulário
  bool validateForm(BuildContext context) {
    if (formKey.currentState!.validate()) {
      return true;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, preencha todos os campos')),
    );
    return false;
  }
}
