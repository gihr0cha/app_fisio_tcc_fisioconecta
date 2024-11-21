import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../utils.dart';

class RegisterPacientsLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? nomepaciente;
  String? sobrenomepaciente;
  String? datanascimentopaciente;

  /// Obtém o nome do fisioterapeuta logado
  String getUserName() {
    return FirebaseUtils.getUserName();
  }
  /// Valida e salva os campos do formulário
   bool validateAndSave(BuildContext context) {
    return FormUtils.validateAndSave(formKey, context);
  }

  /// Salva os dados do paciente no Firebase Realtime Database
  Future<void> savePaciente(BuildContext context) async {
    if (validateAndSave(context)) {
      DatabaseReference dbRef = _database.ref();
      DatabaseReference newPatientRef = dbRef.child('pacientes').push();
      String fisioId = _auth.currentUser!.uid;

      await newPatientRef.set({
        'nome': '$nomepaciente $sobrenomepaciente',
        'data_nascimento': datanascimentopaciente,
        'fisioId': fisioId,
        'sessoes': {},
      });

      await dbRef
          .child('fisioterapeutas')
          .child(fisioId)
          .child('pacientes')
          .update({newPatientRef.key!: true});
    }
  }
}
