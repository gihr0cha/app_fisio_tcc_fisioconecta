import 'package:flutter/material.dart';
import '../logic/fields_final_logic.dart';
import 'home_page.dart';

class FieldsFinal extends StatefulWidget {
  final dynamic paciente;
  final String sessionKey;

  const FieldsFinal({
    super.key,
    required this.paciente,
    required this.sessionKey,
  });

  @override
  State<FieldsFinal> createState() => _FieldsFinalState();
}

class _FieldsFinalState extends State<FieldsFinal> {
  final FieldsFinalLogic _logic = FieldsFinalLogic();
  final PageController _pageController = PageController();

  final List<Map<String, String>> _fieldsFinal = [
    {'label': 'Frequência Cardíaca', 'validator': 'Por favor, insira a frequência cardíaca final'},
    {'label': 'Saturação Periférica de Oxigênio', 'validator': 'Por favor, insira o SpO2 final'},
    {'label': 'Pressão Arterial', 'validator': 'Por favor, insira a PA final'},
    {'label': 'Percepção Subjetiva de Esforço', 'validator': 'Por favor, insira a PSE final'},
    {'label': 'Dor Torácica', 'validator': 'Por favor, insira a dor torácica final'},
    {'label': 'Comentários', 'validator': ''},
  ];

  @override
  void initState() {
    super.initState();
    _logic.initializeSessionKey(widget.sessionKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        title: Text('Formulário de Saúde: ${widget.paciente}'),
      ),
      body: Form(
        key: _logic.formKey,
        child: PageView.builder(
          controller: _pageController,
          itemCount: _fieldsFinal.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AlertDialog(
                backgroundColor: Colors.white,
                content: TextFormField(
                  decoration: InputDecoration(labelText: _fieldsFinal[index]['label']),
                  keyboardType: index == _fieldsFinal.length - 1
                      ? TextInputType.multiline
                      : TextInputType.number,
                  maxLines: index == _fieldsFinal.length - 1 ? null : 1,
                  validator: (value) {
                    if (index != _fieldsFinal.length - 1 && (value == null || value.isEmpty)) {
                      return _fieldsFinal[index]['validator'];
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _logic.updateHealthParameter(index, value);
                  },
                ),
                actions: [
                  if (index < _fieldsFinal.length - 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      ),
                      child: const Text('Próximo', style: TextStyle(color: Colors.white)),
                    ),
                  if (index == _fieldsFinal.length - 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () async {
                        if (_logic.validateForm(context)) {
                          await _logic.saveFinalSession(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        }
                      },
                      child: const Text('Enviar', style: TextStyle(color: Colors.white)),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
