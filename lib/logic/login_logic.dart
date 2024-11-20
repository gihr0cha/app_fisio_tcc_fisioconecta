import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class LoginLogic {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? errorMessage;

  bool validateAndSave(BuildContext context) {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao validar o login')),
      );
      return false;
    }
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
      showMessage(context, errorMessage);
    }
  }

  void showMessage(BuildContext context, String? message) {
    final snackBar = SnackBar(
      content: Text(message!),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
