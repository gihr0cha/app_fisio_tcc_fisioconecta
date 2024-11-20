import 'package:flutter/material.dart';
import '../logic/fields_inicial_logic.dart';
import '../widgets/fieldsExercicios.dart';

class FieldsInicial extends StatefulWidget {
  final dynamic paciente;
  final List<Map<String, dynamic>> selectedFields;

  const FieldsInicial({
    super.key,
    required this.selectedFields,
    required this.paciente,
  });

  @override
  State<FieldsInicial> createState() => _FieldsInicialState();
}

class _FieldsInicialState extends State<FieldsInicial> {
  final FieldsInicialLogic _logic = FieldsInicialLogic();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _logic.generateSessionKey(widget.paciente);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        title: Text('Formulário de Saúde: ${widget.paciente['nome']}'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Form(
          key: _logic.formKey,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.selectedFields.length,
            itemBuilder: (context, index) {
              return _buildField(context, index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildField(BuildContext context, int index) {
    final field = widget.selectedFields[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        backgroundColor: Colors.white,
        content: TextFormField(
          decoration: InputDecoration(labelText: field['label']),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, preencha este campo';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              field['value'] = value;
            });
          },
        ),
        actions: [
          if (index < widget.selectedFields.length - 1)
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              ),
              child: const Text('Próximo', style: TextStyle(color: Colors.white)),
            ),
          if (index == widget.selectedFields.length - 1)
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                if (_logic.validateForm(context)) {
                  await _logic.saveInitialSession(widget.paciente, widget.selectedFields);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FieldsExercicio(
                        sessionKey: _logic.customSessionKey,
                        paciente: widget.paciente,
                      ),
                    ),
                  );
                }
              },
              child: const Text('Enviar', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}
