import 'package:flutter/material.dart';
import '../logic/criar_exercicio_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CriarExercicio extends StatefulWidget {
  const CriarExercicio({super.key});

  @override
  State<CriarExercicio> createState() => _CriarExercicioState();
}

class _CriarExercicioState extends State<CriarExercicio> {
  final CriarExercicioLogic _logic = CriarExercicioLogic();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final nome = (user?.displayName ?? '').split(' ')[0];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        title: Text('Bem-vindo $nome'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Cadastrar Exercício',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
            Form(
              key: _logic.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Nome do Exercício',
                    ),
                    validator: (value) => value!.isEmpty ? 'inválido' : null,
                    onSaved: (newValue) => _logic.nomeExercicio = newValue,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () => _logic.addExercicio(context),
                      child: const Text(
                        'Enviar',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
