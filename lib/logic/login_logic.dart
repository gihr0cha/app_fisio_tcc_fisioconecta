import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'utils.dart';

class LoginLogic {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? errorMessage;

  bool validateAndSave(BuildContext context) {
    return FormUtils.validateAndSave(formKey, context);
  }

  Future<void> validateAndSubmit(BuildContext context) async {
    try {
      if (validateAndSave(context)) {
        UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário logado: ${user.user!.uid}')),
        );
        if (Navigator.canPop(context)) context.go('/home');
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        errorMessage = switch (e.code) {
          "user-not-found" => 'Nenhum usuário encontrado',
          "wrong-password" => 'Senha errada',
          _ => 'Erro',
        };
      } else {
        errorMessage = 'Erro desconhecido';
      }
      FormUtils.showMessage(context, errorMessage);
    }
  }
}
