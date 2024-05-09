import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FormsSessao extends StatefulWidget {
  final dynamic paciente ;
  const FormsSessao({Key? key, required this.paciente}) : super(key: key);


  @override
  FormsSessaoState createState() => FormsSessaoState();
  
}
class FormsSessaoState extends State<FormsSessao> {
final user = FirebaseAuth.instance.currentUser;
FirebaseDatabase database = FirebaseDatabase.instance;
  final _formKey = GlobalKey<FormState>();
  final _controller = PageController();
  dynamic paciente;

  @override
  void initState() {
    super.initState();
    paciente = widget.paciente;
  }
  
  

  final _fieldsinicial = [
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

  final _fieldsfinal = [
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

  
  Map<String, dynamic> healthParametersinicial = {
  'freqCardiacaInicial': null,
  'spo2Inicial': null,
  'paInicial': null,
  'pseInicial': null,
  'dorToracicaInicial': null,
};

Map<String, dynamic> healthParametersfinal = {
  'freqCardiacaFianl': null,
  'spo2Final': null,
  'paFinal': null,
  'pseFinal': null,
  'dorToracicaFinal': null,
};




  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      print(healthParametersinicial);
      return true;
    }
    else{
      print('não salvou');
      return false;
      }
  }

void validateAndSubmit() {
  if (validateAndSave()) {
    // Cria um novo nó para a sessão sob 'sessoes'
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    DatabaseReference newSessionRef = dbRef.child('sessoes').push();

   newSessionRef.set({
      'sessoes':{
      'inicio_sessao': healthParametersinicial,
      'fim_sessao': {},
    }});

    // Adiciona o ID da sessão à lista de sessões do paciente
    dbRef.child('pacientes').child(widget.paciente).child('sessoes').update({
      newSessionRef.key!: true
    });

    print(database);
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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AlertDialog(
                content: TextFormField(
                  decoration:
                      InputDecoration(labelText: _fieldsinicial[index]['label']),
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
                          healthParametersinicial['freqCardiacaInicial'] = value;
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
                      child: const Text('Next'),
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
          },
        ),
      ),
    );
  }
}
