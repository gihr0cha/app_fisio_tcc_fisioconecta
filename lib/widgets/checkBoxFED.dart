import 'package:flutter/material.dart';
import '../logic/checkbox_fed_logic.dart';
import '../pages/fields_inicial_page.dart';

class CheckBoxFED extends StatefulWidget {
  final dynamic paciente;

  const CheckBoxFED({super.key, required this.paciente});

  @override
  State<CheckBoxFED> createState() => _CheckBoxFEDState();
}

class _CheckBoxFEDState extends State<CheckBoxFED> {
  final CheckBoxFEDLogic _logic = CheckBoxFEDLogic();

  void _onSubmit() {
    final selectedFields = _logic.getSelectedFields();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FieldsInicial(
          selectedFields: selectedFields,
          paciente: widget.paciente,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione os Campos'),
      ),
      body: ListView.builder(
        itemCount: _logic.availableFields.length,
        itemBuilder: (context, index) {
          final field = _logic.availableFields[index];
          return CheckboxListTile(
            title: Text(field['label']),
            value: field['selected'],
            onChanged: (selected) {
              setState(() {
                _logic.onFieldSelected(selected, index);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSubmit,
        child: const Icon(Icons.check),
      ),
    );
  }
}
