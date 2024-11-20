import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditPacienteLogic {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? nomepaciente;
  String? sobrenomepaciente;
  String? datanascimentopaciente;

  /// Inicializa os dados do paciente a partir do mapa recebido
  void initializePacienteData(Map<dynamic, dynamic> pacienteData) {
    final nomeCompleto = pacienteData['nome'].split(' ');
    nomepaciente = nomeCompleto.first;
    sobrenomepaciente = nomeCompleto.length > 1 ? nomeCompleto.skip(1).join(' ') : '';
    datanascimentopaciente = pacienteData['data_nascimento'];
  }

  /// Valida e salva os dados do formulário
  bool validateAndSave(BuildContext context) {
    // essa funcao nao precisa ser reescrita, pois é a mesma do arquivo register_pacients_logic.dart e pode ser reutilizada 
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preencha os campos corretamente!')),
    );
    return false;
  }

  /// Atualiza os dados do paciente no Firebase
  Future<void> updatePaciente(Map<dynamic, dynamic> pacienteData, BuildContext context) async {
    if (validateAndSave(context)) {
      DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      await dbRef.child('pacientes/${pacienteData['key']}').update({
        'nome': '$nomepaciente $sobrenomepaciente',
        'data_nascimento': datanascimentopaciente,
      });
      Navigator.pop(context); // Retorna à tela anterior após a atualização
    }
  }
}
