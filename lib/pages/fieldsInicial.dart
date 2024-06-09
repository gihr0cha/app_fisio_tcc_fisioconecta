import 'package:app_fisio_tcc/pages/fieldsExercicios.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FieldsInicial extends StatefulWidget {
  final dynamic paciente;
  const FieldsInicial({Key? key, required this.paciente}) : super(key: key);

  @override
  _FieldsInicialState createState() => _FieldsInicialState();
}

class _FieldsInicialState extends State<FieldsInicial> {
  final user = FirebaseAuth.instance.currentUser;
  final database = FirebaseDatabase.instance;
  final _formKey = GlobalKey<FormState>();
  final _controller = PageController();
  dynamic paciente;

  final _fieldsinicial = const [
    {
      'label': 'Frequência Cardíaca',
      'validator': 'Por favor, insira a frequência cardíaca inicial'
    },
    {'label': 'SpO2', 'validator': 'Por favor, insira o SpO2 inicial'},
    {'label': 'PA', 'validator': 'Por favor, insira a PA inicial'},
    {'label': 'PSE', 'validator': 'Por favor, insira a PSE inicial'},
    {
      'label': 'Dor Torácica',
      'validator': 'Por favor, insira a dor torácica inicial'
    },
  ];

  Map<String, dynamic> healthParametersinicial = {
    'freqCardiacaInicial': null,
    'spo2Inicial': null,
    'paInicial': null,
    'pseInicial': null,
    'dorToracicaInicial': null,
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

  void validateAndSubmit() {
    if (validateAndSave()) {
      DatabaseReference dbRef = database.ref();
      DatabaseReference newSessionRef = dbRef.child('sessoes').push();


      newSessionRef.set({
          'inicio_sessao': healthParametersinicial,
          'exercise': '',
          'fim_sessao': ''
      });

      dbRef
          .child('pacientes')
          .child(widget.paciente)
          .child('sessoes')
          .update({newSessionRef.key!: true});

      print(database);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FieldsExercicio(
            paciente: widget.paciente,
          ), 
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Saúde: ${widget.paciente['nome']}'),
      ),
      body: Form(
        key: _formKey,
        child: PageView.builder(
          controller: _controller,
          itemCount: _fieldsinicial.length,
          itemBuilder: (context, index) {
            return buildField(context, index);
          },
        ),
      ),
    );
  }

  Widget buildField(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        content: TextFormField(
          decoration: InputDecoration(
              labelText: _fieldsinicial[index]['label']),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _fieldsinicial[index]['validator'];
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              switch (index) {
                case 0:
                  healthParametersinicial['freqCardiacaInicial'] =
                      value;
                  break;
                case 1:
                  healthParametersinicial['spo2Inicial'] = value;
                  break;
                case 2:
                  healthParametersinicial['paInicial'] = value;
                  break;
                case 3:
                  healthParametersinicial['pseInicial'] = value;
                  break;
                case 4:
                  healthParametersinicial['dorToracicaInicial'] = value;
                  break;
              }
            });
          },
        ),
        actions: [
          if (index < _fieldsinicial.length - 1)
            ElevatedButton(
              onPressed: () => _controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              ),
              child: const Text('Próximo'),
            ),
          if (index == _fieldsinicial.length - 1)
            ElevatedButton(
              onPressed: () {
                print(paciente);
                if (_formKey.currentState!.validate()) {
                  validateAndSubmit();

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
  }
}
