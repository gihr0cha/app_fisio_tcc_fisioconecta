import 'package:flutter/material.dart';
import '../logic/register_pacients_logic.dart';

class RegisterPacients extends StatefulWidget {
  const RegisterPacients({super.key});

  @override
  State<RegisterPacients> createState() => _RegisterPacientsState();
}

class _RegisterPacientsState extends State<RegisterPacients> {
  final RegisterPacientsLogic _logic = RegisterPacientsLogic();

  @override
  Widget build(BuildContext context) {
    final nome = _logic.getUserName();

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
              key: _logic.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Nome do Paciente',
                    ),
                    validator: (value) => value!.isEmpty ? 'inválido' : null,
                    onSaved: (newValue) => _logic.nomepaciente = newValue,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Sobrenome do Paciente',
                    ),
                    validator: (value) => value!.isEmpty ? 'inválido' : null,
                    onSaved: (newValue) => _logic.sobrenomepaciente = newValue,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      hintText: 'Data de nascimento',
                    ),
                    validator: (value) => value!.isEmpty ? 'inválido' : null,
                    onSaved: (newValue) =>
                        _logic.datanascimentopaciente = newValue,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () => _logic.savePaciente(context),
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
