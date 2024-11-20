import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'firebase_utils.dart';

class CriarExercicioLogic {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? nomeExercicio;

  /// Valida e salva o formulário
  bool validateAndSave(BuildContext context) {
    return FormUtils.validateAndSave(formKey, context);
  }

  /// Adiciona um novo exercício ao Firebase Realtime Database
  Future<void> addExercicio(BuildContext context) async {
    if (validateAndSave(context)) {
      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('exercicios');
      String? exerciseId = dbRef.push().key;

      await dbRef.update({
        exerciseId!: nomeExercicio,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercício cadastrado com sucesso!')),
      );
    }
  }
}
