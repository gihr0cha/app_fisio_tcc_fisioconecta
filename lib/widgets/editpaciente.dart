import 'package:flutter/material.dart';
import '../logic/edit_paciente_logic.dart';

class EditPaciente extends StatefulWidget {
  final Map<dynamic, dynamic> pacienteData;

  const EditPaciente({super.key, required this.pacienteData});

  @override
  State<EditPaciente> createState() => _EditPacienteState();
}

class _EditPacienteState extends State<EditPaciente> {
  final EditPacienteLogic _logic = EditPacienteLogic();

  @override
  void initState() {
    super.initState();
    _logic.initializePacienteData(widget.pacienteData);
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
        title: const Text(
          'Editar Paciente',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _logic.formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _logic.nomepaciente,
                decoration: const InputDecoration(
                  hintText: 'Nome do Paciente',
                ),
                validator: (value) => value!.isEmpty ? 'inválido' : null,
                onSaved: (newValue) => _logic.nomepaciente = newValue,
              ),
              TextFormField(
                initialValue: _logic.sobrenomepaciente,
                decoration: const InputDecoration(
                  hintText: 'Sobrenome do Paciente',
                ),
                validator: (value) => value!.isEmpty ? 'inválido' : null,
                onSaved: (newValue) => _logic.sobrenomepaciente = newValue,
              ),
              TextFormField(
                initialValue: _logic.datanascimentopaciente,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  hintText: 'Data de Nascimento',
                ),
                validator: (value) => value!.isEmpty ? 'inválido' : null,
                onSaved: (newValue) => _logic.datanascimentopaciente = newValue,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () =>
                      _logic.updatePaciente(widget.pacienteData, context),
                  child: const Text(
                    'Atualizar',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
