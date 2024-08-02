import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CriarExercicio extends StatefulWidget {
  const CriarExercicio({super.key});

  @override
  State<CriarExercicio> createState() => _CriarExercicioState();
}

// A classe _CriarExercicioState é um StatefulWidget que cria um formulário para o fisioterapeuta inserir o nome do exercício que deseja adicionar ao banco de dados
class _CriarExercicioState extends State<CriarExercicio> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  FirebaseDatabase database = FirebaseDatabase.instance;
  String? nomeExercicio;
// O método validateAndSave valida o formulário e salva o nome do exercício no estado do widget
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

// O método validateAndSubmit chama o método validateAndSave e, se o formulário for válido, cria um novo nó no banco de dados Firebase Realtime Database para o exercício
  void validateAndSubmit() async {
    if (validateAndSave()) {
      // Cria um novo nó para o exercício sob 'exercicios'
      DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      DatabaseReference newExerciseRef = dbRef.child('exercicios');

      // Generate a unique ID for the exercise
      String? exerciseId = newExerciseRef.push().key;
// O método update atualiza o nó do exercício com o nome do exercício inserido pelo fisioterapeuta
      await newExerciseRef.update({
        exerciseId!: nomeExercicio,
      });

      print(database);
    }
  }

// O método build cria um formulário com um campo de texto para o nome do exercício e um botão para enviar o formulário
  @override
  Widget build(BuildContext context) {
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

      // O formulário é criado com um campo de texto para o nome do exercício
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Nome do Exercicio',
                    ),
                    // O validador verifica se o campo está vazio e exibe uma mensagem de erro se estiver
                    validator: (value) => value!.isEmpty ? 'inválido' : null,
                    onSaved: (newValue) => nomeExercicio = newValue,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: validateAndSubmit,
                      child: const Text('Enviar', style: TextStyle(fontSize: 20, color: Colors.white)),
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
