import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FieldsFinal extends StatefulWidget {
  final dynamic paciente;
  const FieldsFinal({Key? key, required this.paciente, required sessionKey}) : super(key: key);

  @override
  _FieldsFinalState createState() => _FieldsFinalState();
}

class _FieldsFinalState extends State<FieldsFinal> {
  final user = FirebaseAuth.instance.currentUser;
  final database = FirebaseDatabase.instance;
  final _formKey = GlobalKey<FormState>();
  final _controller = PageController();
  dynamic paciente;
  dynamic sessionKey;

  final _fieldsfinal = const [
    {
      'label': 'Frequência Cardíaca',
      'validator': 'Por favor, insira a frequência cardíaca final'
    },
    {'label': 'SpO2', 'validator': 'Por favor, insira o SpO2 final'},
    {'label': 'PA', 'validator': 'Por favor, insira a PA final'},
    {'label': 'PSE', 'validator': 'Por favor, insira a PSE final'},
    {
      'label': 'Dor Torácica',
      'validator': 'Por favor, insira a dor torácica final'
    },
  ];

  Map<String, dynamic> healthParametersfinal = {
    'freqCardiacaFinal': null,
    'spo2Final': null,
    'paFinal': null,
    'pseFinal': null,
    'dorToracicaFinal': null,
  };

  @override
  void initState() {
    super.initState();
    paciente = widget.paciente;
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      print('Formulário não salvo');
      return false;
    }
  }

  void validadeAndSubmit() {
    if (validateAndSave()) {
      DatabaseReference dbRef = database.ref();
      DatabaseReference sessionRef =
          dbRef.child('sessoes').child(sessionKey).child('fielsfinal');
          sessionRef.update({
            'healthParametersfinal': healthParametersfinal,
          });
      _controller.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Saúde: ${widget.paciente}'),
      ),
      backgroundColor: Colors.green,
      body: Form(
        key: _formKey,
        child: PageView.builder(
          controller: _controller,
          itemCount: _fieldsfinal.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AlertDialog(
                content: TextFormField(
                  decoration:
                      InputDecoration(labelText: _fieldsfinal[index]['label']),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _fieldsfinal[index]['validator'];
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      switch (index) {
                        case 0:
                          healthParametersfinal['freqCardiacaFinal'] = value;
                          break;
                        case 1:
                          healthParametersfinal['spo2Final'] = value;
                          break;
                        case 2:
                          healthParametersfinal['paFinal'] = value;
                          break;
                        case 3:
                          healthParametersfinal['pseFinal'] = value;
                          break;
                        case 4:
                          healthParametersfinal['dorToracicaFinal'] = value;
                          break;
                      }
                    });
                  },
                ),
                actions: [
                  if (index < _fieldsfinal.length - 1)
                    ElevatedButton(
                      onPressed: () => _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      ),
                      child: const Text('Próximo'),
                    ),
                  if (index == _fieldsfinal.length - 1)
                    ElevatedButton(
                      onPressed: () {
                        print(paciente);
                        if (_formKey.currentState!.validate()) {
                          validadeAndSubmit();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processando Dados')),
                          );
                        }
                      },
                      child: const Text('Enviar'),
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
