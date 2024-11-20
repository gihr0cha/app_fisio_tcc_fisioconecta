import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../utils.dart';

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

  void initializeSessionKey(String key) {
    sessionKey = key;
  }

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

  Future<void> saveFinalSession(BuildContext context) async {
    DatabaseReference sessionRef = _database.ref().child('sessoes').child(sessionKey);

    await FormUtils.saveData(sessionRef, {'final_sessao': healthParametersFinal}, context);
  }

  bool validateForm(BuildContext context) {
    return FormUtils.validateAndSave(formKey, context);
  }
}
