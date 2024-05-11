import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CriarExercicio extends StatefulWidget {
  const CriarExercicio({super.key});

  @override
  State<CriarExercicio> createState() => _CriarExercicioState();
}

class _CriarExercicioState extends State<CriarExercicio> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  FirebaseDatabase database = FirebaseDatabase.instance;
  String? nomeExercicio;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      // Cria um novo nó para o exercício sob 'exercicios'
      DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      DatabaseReference newExerciseRef = dbRef.child('exercicios').push();

      await newExerciseRef.set({
        'nome':
            nomeExercicio, // Aqui você deve substituir 'nomeExercicio' pelo nome do exercício que você deseja adicionar
      });

      print(database);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nome = user?.displayName ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo $nome'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Nome do Exercicio',
              ),
              validator: (value) => value!.isEmpty ? 'inválido' : null,
              onSaved: (newValue) => nomeExercicio = newValue,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: validateAndSubmit,
                child: const Text('Enviar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
