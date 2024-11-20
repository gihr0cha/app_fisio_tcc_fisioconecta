import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Obtém o nome do usuário logado
  String getUserName() {
    final user = _auth.currentUser;
    return (user?.displayName ?? '').split(' ')[0];
  }

  /// Faz logout e navega para a página de login
  void logout(BuildContext context) {
    _auth.signOut();
    Navigator.popAndPushNamed(context, '/login');
  }
}
