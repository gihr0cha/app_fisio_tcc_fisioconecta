import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditPaciente extends StatefulWidget {
  final Map<dynamic, dynamic> pacienteData;
  const EditPaciente({super.key, required this.pacienteData});

  @override
  State<EditPaciente> createState() => _EditPacienteState();
}

class _EditPacienteState extends State<EditPaciente> {
  final _formKey = GlobalKey<FormState>();
  String? nomepaciente;
  String? sobrenomepaciente;
  String? datanascimentopaciente;



  @override
  void initState() {
    super.initState();
    final nomeCompleto = widget.pacienteData['nome'].split(' ');
    nomepaciente = nomeCompleto.first;
    sobrenomepaciente = nomeCompleto.length > 1 ? nomeCompleto.skip(1).join(' ') : '';
    datanascimentopaciente = widget.pacienteData['data_nascimento'];
  }

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
      DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      await dbRef.child('pacientes/${widget.pacienteData['key']}').update({
        'nome': '$nomepaciente $sobrenomepaciente',
        'data_nascimento': datanascimentopaciente,
      });
      Navigator.pop(context); // Retorna à tela anterior após a atualização
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Editar Paciente', style: TextStyle(color: Colors.white)),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              initialValue: nomepaciente,
              decoration: const InputDecoration(
                hintText: 'Nome do Paciente',
              ),
              validator: (value) => value!.isEmpty ? 'inválido' : null,
              onSaved: (newValue) => nomepaciente = newValue,
            ),
            TextFormField(
              initialValue: sobrenomepaciente,
              decoration: const InputDecoration(
                hintText: 'Sobrenome do Paciente',
              ),
              validator: (value) => value!.isEmpty ? 'inválido' : null,
              onSaved: (newValue) => sobrenomepaciente = newValue,
            ),
            TextFormField(
              initialValue: datanascimentopaciente,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                hintText: 'Data de Nascimento',
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
                child: const Text('Atualizar', style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}