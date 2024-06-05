import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FormsSessao extends StatefulWidget {
  final dynamic paciente;
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
  String? nomeExercicio;
  String? _selectedExercise;
  int _numOfSeries = 1;
  List<TextEditingController> _controllers = [TextEditingController()];

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
    'freqCardiacaFinal': null,
    'spo2Final': null,
    'paFinal': null,
    'pseFinal': null,
    'dorToracicaFinal': null,
  };

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      print('não salvou');
      return false;
    }
  }

  void validateAndSubmitinicial() {
    if (validateAndSave()) {
      // Cria um novo nó para a sessão sob 'sessoes'
      DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      DatabaseReference newSessionRef = dbRef.child('sessoes').push();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => build2(context)));

      newSessionRef.set({
        'sessoes': {
          'inicio_sessao': healthParametersinicial,
          'exercise': '',
          'fim_sessao': ''
        }
      });

      // Adiciona o ID da sessão à lista de sessões do paciente
      dbRef
          .child('pacientes')
          .child(widget.paciente)
          .child('sessoes')
          .update({newSessionRef.key!: true});

      print(database);
    }
  }

  void validateAndSubmitExercicio() async {}

  void validateAndSubmitFinal() async {}

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
                      child: const Text('Next'),
                    ),
                  if (index == _fieldsinicial.length - 1)
                    ElevatedButton(
                      onPressed: () {
                        print(paciente);
                        if (_formKey.currentState!.validate()) {
                          validateAndSubmitinicial();
                          build2(context);

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

  Widget build2(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        children: [
          StreamBuilder(
            stream: database.ref('exercicios').onValue,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
                Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
                Map<String, dynamic> formattedMap = {};
                map.forEach((key, value) {
                  formattedMap[key.toString()] = value;
                });
                return DropdownButton<String>(
                  value: _selectedExercise,
                  hint: const Text('Selecione um exercício'),
                  items: formattedMap.values
                      .toList()
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedExercise = newValue;
                    });
                  },
                );
              } else {
                print(snapshot);
                return const CircularProgressIndicator();
              }
            },
          ),
          DropdownButton<int>(
            value: _numOfSeries,
            items: [1, 2, 3, 4, 5].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value séries'),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                _numOfSeries = newValue!;
                _controllers = List.generate(
                    _numOfSeries, (index) => TextEditingController());
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _numOfSeries,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      labelText:
                          'Número de repetições para a série ${index + 1}',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_selectedExercise != null) {
                database.ref('exercicios').child(_selectedExercise!).update({
                  'series': _controllers
                      .map((controller) => controller.text)
                      .toList(),
                });
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Widget build3(BuildContext context) {
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
                          validateAndSubmitFinal();

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
