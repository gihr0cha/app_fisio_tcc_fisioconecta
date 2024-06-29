import 'package:app_fisio_tcc/pages/fieldsFinal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FieldsExercicio extends StatefulWidget {
  final dynamic paciente;
  final dynamic sessionKey;

  const FieldsExercicio(
      {Key? key, required this.paciente, required this.sessionKey})
      : super(key: key);

  @override
  _FieldsExercicioState createState() => _FieldsExercicioState();
}

class _FieldsExercicioState extends State<FieldsExercicio> {
  String? _selectedExercise;
  int _numOfSeries = 1;
  var _controllers = <TextEditingController>[];
  late String sessionKey;
  final _database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    sessionKey = widget.sessionKey;
    for (int i = 0; i < _numOfSeries; i++) {
      _controllers.add(TextEditingController());
    }
  }

  validateAndSave() {
    if (_selectedExercise != null) {
      DatabaseReference dbRef = _database.ref();
      DatabaseReference sessionRef =
          dbRef.child('sessoes').child(sessionKey).child('exercicios');

      List<String> weights = [];
      for (int i = 0; i < _numOfSeries; i++) {
        weights.add(_controllers[i].text);
      }

      sessionRef.update({
        _selectedExercise.toString(): {
          'series': _numOfSeries,
          'weights': weights,
        },
      });

      // Limpar os campos de texto e redefinir o exercício selecionado e o número de séries
      _selectedExercise = null;
      _numOfSeries = 1;
      for (var controller in _controllers) {
        controller.clear();
      }
      _controllers.length = _numOfSeries;

      print('Dados salvos com sucesso!');
    } else {
      print('Por favor, selecione um exercício.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      backgroundColor: Colors.green,
     
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          StreamBuilder(
            stream: _database.ref('exercicios').onValue,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
                Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
                Map<String, String> formattedMap = {};
                map.forEach((key, value) {
                  formattedMap[key.toString()] = value.toString();
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
                child: Text('$value série(s)'),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                _numOfSeries = newValue!;
                _controllers = List.generate(_numOfSeries, (index) {
                  return TextEditingController();
                  // controller é um objeto que controla um campo de texto
                });
              });
            },
          ),
          for (int i = 0; i < _numOfSeries; i++)
            TextFormField(
              controller: _controllers[i],
              decoration: InputDecoration(
                labelText: 'Peso da série ${i + 1}',
              ),
            ),
          ElevatedButton(
            onPressed: () {
              print(_selectedExercise);
              print(_numOfSeries);

              // Ensure _controllers has enough elements
              while (_controllers.length < _numOfSeries) {
                _controllers.add(TextEditingController());
              }

              for (int i = 0; i < _numOfSeries; i++) {
                print(_controllers[i].text);
              }
              validateAndSave();
            },
            child: const Text('Salvar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FieldsFinal(
                    paciente: widget.paciente,
                    sessionKey: sessionKey,
                  ),
                ),
              );
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    return scaffold;
  }
}
