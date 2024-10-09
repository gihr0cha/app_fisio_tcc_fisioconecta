import 'package:flutter/material.dart';
import 'fieldsInicial.dart';


class CheckBoxFED extends StatelessWidget {
  final dynamic paciente;
  CheckBoxFED({super.key, required this.paciente});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _availableFields = [
      {'label': 'Frequência Cardíaca', 'selected': false},
      {'label': 'SPO2', 'selected': false},
      {'label': 'Pressão Arterial', 'selected': false},
      {'label': 'Percepção Subjetiva de Esforço', 'selected': false},
      {'label': 'Dor', 'selected': false},
    ];
    void _onFieldSelected(bool? selected, int index) {
      _availableFields[index]['selected'] = selected;
    }

    void _onSubmit() {
      final selectedFields =
          _availableFields.where((field) => field['selected']).toList();
      // Navegue para a página de formulário passando os campos selecionados
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FieldsInicial(selectedFields: selectedFields, paciente: paciente),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Selecione os Campos')),
      body: ListView.builder(
        itemCount: _availableFields.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(_availableFields[index]['label']),
            value: _availableFields[index]['selected'],
            onChanged: (selected) => _onFieldSelected(selected, index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSubmit,
        child: Icon(Icons.check),
      ),
    );
  }
}
