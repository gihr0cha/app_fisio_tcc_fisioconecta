import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateAccountLogic {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? name;
  String? errorMessage;

  bool validateAndSave(BuildContext context) {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit(BuildContext context) async {
    if (validateAndSave(context)) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        await userCredential.user!.updateDisplayName(name);

        // Salvar dados no Firebase Realtime Database
        final personalizedId = '${email!.split('@')[0]}_${userCredential.user!.uid}';
        DatabaseReference dbRef = FirebaseDatabase.instance.ref();
        dbRef.child('fisioterapeutas').child(personalizedId).set({
          'nome': name,
          'pacientes': {}, // Inicialmente sem pacientes
        });

        if (context.mounted) {
          context.go('/home');
        }
      } on FirebaseAuthException catch (e) {
        errorMessage = switch (e.code) {
          'weak-password' => 'A senha fornecida é muito fraca',
          'email-already-in-use' => 'Esse e-mail já está em uso',
          _ => 'Erro desconhecido',
        };
        showMessage(context, errorMessage);
      } catch (e) {
        errorMessage = 'Erro desconhecido';
        showMessage(context, errorMessage);
      }
    }
  }

  void showMessage(BuildContext context, String? errorMessage) {
    final snackBar = SnackBar(
      content: Text(errorMessage!),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
