import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils.dart';

class CreateAccountLogic {
  // Chave global para o formulário de cadastro
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? name;
  String? errorMessage;

bool validateAndSave(BuildContext context) {
    return FormUtils.validateAndSave(formKey, context);
  }

  Future<void> validateAndSubmit(BuildContext context) async {
    // Valida e salva os campos do formulário, da para usar essa função em qualquer lugar (não só no botão de cadastro)
    if (validateAndSave(context)) {
      try {
        // Cria um novo usuário com e-mail e senha
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
          // a função mounted verifica se o widget está montado na árvore de widgets
          context.go('/home');
        }
      } on FirebaseAuthException catch (e) {
        // Tratamento de erros, exibindo uma mensagem de erro ao usuário
        errorMessage = switch (e.code) {
          'weak-password' => 'A senha fornecida é muito fraca',
          'email-already-in-use' => 'Esse e-mail já está em uso',
          _ => 'Erro desconhecido',
        };
        FormUtils.showMessage(context, errorMessage);
        // o context é passado para a função para que a mensagem de erro possa ser exibida na tela, mas não é necessário 
      } catch (e) {
        // o catch genérico captura qualquer erro que não seja do tipo FirebaseAuthException 
        errorMessage = 'Erro desconhecido';
        FormUtils.showMessage(context, errorMessage);
      }
    }
  }
}