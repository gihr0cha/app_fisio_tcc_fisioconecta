import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FieldsFinalLogic {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String sessionKey;

  Map<String, dynamic> healthParametersFinal = {
    'freqCardiacaFinal': null,
    'spo2Final': null,
    'paFinal': null,
    'pseFinal': null,
    'dorToracicaFinal': null,
    'comentario': null,
  };

  /// Inicializa a chave da sessão
  void initializeSessionKey(String key) {
    sessionKey = key;
  }

  /// Atualiza o parâmetro final com base no índice
  void updateHealthParameter(int index, String value) {
    switch (index) {
      case 0:
        healthParametersFinal['freqCardiacaFinal'] = value;
        break;
      case 1:
        healthParametersFinal['spo2Final'] = value;
        break;
      case 2:
        healthParametersFinal['paFinal'] = value;
        break;
      case 3:
        healthParametersFinal['pseFinal'] = value;
        break;
      case 4:
        healthParametersFinal['dorToracicaFinal'] = value;
        break;
      case 5:
        healthParametersFinal['comentario'] = value;
        break;
    }
  }

  /// Salva os parâmetros finais no Firebase
  Future<void> saveFinalSession(BuildContext context) async {
    DatabaseReference sessionRef = _database.ref().child('sessoes').child(sessionKey);

    await sessionRef.update({
      'final_sessao': healthParametersFinal,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados salvos com sucesso!')),
    );
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
