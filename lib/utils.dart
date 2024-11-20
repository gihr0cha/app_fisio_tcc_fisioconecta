import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseUtils {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  // Retorna o nome do usuário logado
  static String getUserName() {
    final user = _auth.currentUser;
    return (user?.displayName ?? '').split(' ')[0];
  }
  // Formata os dados do snapshot do Firebase para um mapa utilizável
  static Map<String, dynamic> formatDatabaseSnapshot(Map<dynamic, dynamic> map) {
    Map<String, dynamic> formattedMap = {};
    map.forEach((key, value) {
      formattedMap[key.toString()] = value;
    });
    return formattedMap;
  }
}

class FormUtils {
  static bool validateAndSave(GlobalKey<FormState> formKey, BuildContext context) {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao validar o formulário')),
      );
      return false;
    }
  }

  static void showMessage(BuildContext context, String? message) {
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