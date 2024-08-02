import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPacients extends StatefulWidget {
  const RegisterPacients({super.key});

  @override
  State<RegisterPacients> createState() => _RegisterPacientsState();
}

class _RegisterPacientsState extends State<RegisterPacients> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final rtdb = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://fisioconecta-b9fcf-default-rtdb.firebaseio.com/');
  FirebaseDatabase database = FirebaseDatabase.instance;
  String? nomepaciente;
  String? sobrenomepaciente;
  String? datanascimentopaciente;

  String fisio =
      'fisioterapeutas/${FirebaseAuth.instance.currentUser?.displayName}';

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paciente salvo com sucesso!'),
        ),
      );
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      // Cria um novo nó para o paciente sob 'pacientes'
      DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      DatabaseReference newPatientRef = dbRef.child('pacientes').push();
      String fisioId = FirebaseAuth.instance.currentUser!.uid;

      await newPatientRef.set({
        'nome':
            '$nomepaciente $sobrenomepaciente', // Concatena o nome e sobrenome
        'data_nascimento': datanascimentopaciente,
        'fisioId': fisioId,
        'sessoes': {} // Inicialmente, o paciente não tem sessões associadas
      });

      // Adiciona o ID do paciente à lista de pacientes do fisioterapeuta
      dbRef
          .child('fisioterapeutas')
          .child(fisioId)
          .child('pacientes')
          .update({newPatientRef.key!: true});
    }
  }

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
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Cadastrar Paciente',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Nome do Paciente',
                    ),
                    validator: (value) => value!.isEmpty ? 'inválido' : null,
                    onSaved: (newValue) => nomepaciente = newValue,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Sobrenome do Paciente',
                    ),
                    validator: (value) => value!.isEmpty ? 'inválido' : null,
                    onSaved: (newValue) => sobrenomepaciente = newValue,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      hintText: 'data de nascimento',
                    ),
                    validator: (value) => value!.isEmpty ? 'inválido' : null,
                    onSaved: (newValue) => datanascimentopaciente = newValue,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: validateAndSubmit,
                      child: const Text('Enviar',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
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
