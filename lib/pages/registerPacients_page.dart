import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../assets/theme_app.dart';
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
  String? email;
  String paciente = 'paciente';

  String fisio =
      'fisioterapeutas/${FirebaseAuth.instance.currentUser!.displayName}';

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      print(nomepaciente);
      paciente = nomepaciente!;
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() {
    if (validateAndSave()) {
      database.ref().child(fisio).push().set({
        paciente: {
          'nome': nomepaciente,
          'email': email,
        }
      });
      print(database);
      final snackBar = SnackBar(content: Text('Dados salvos com sucesso!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _formKey.currentState!.reset(); // This line has been added
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade500,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.arrow_back))
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
              child: const Text(
                'Preencha o formulário abaixo para cadastrar um novo paciente',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: AppTheme.themeData.inputDecorationTheme.labelStyle,
                    decoration: InputDecoration(
                        label: const Text(
                          'Nome do Paciente:',
                          style: TextStyle(color: Colors.black87),
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    validator: (value) => value!.isEmpty ? 'inválido' : null,
                    onSaved: (newValue) => nomepaciente = newValue,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    validator: (value) => value!.isEmpty ? 'inválido' : null,
                    onSaved: (newValue) => email = newValue,
                    style: AppTheme.themeData.inputDecorationTheme.labelStyle,
                    decoration: InputDecoration(
                        label: const Text(
                          'Email do Paciente:',
                          style: TextStyle(color: Colors.black87),
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    style: AppTheme.themeData.inputDecorationTheme.labelStyle,
                    decoration: InputDecoration(
                        label: const Text(
                          'Data de Nacimento:',
                          style: TextStyle(color: Colors.black87),
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(height: 24),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: validateAndSubmit,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size(
                              200, 70), // New line to increase the button size
                        ),
                        child: const Text('Salvar'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
