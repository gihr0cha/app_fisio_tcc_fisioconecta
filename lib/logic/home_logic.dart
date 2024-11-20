import 'firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getUserName() {
    return FirebaseUtils.getUserName();
  }

  /// Faz logout e navega para a página de login
  void logout(BuildContext context) {
    _auth.signOut();
    Navigator.popAndPushNamed(context, '/login');
  }
}
