import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FieldsExercicio extends StatefulWidget {
  const FieldsExercicio({Key? key, required paciente}) : super(key: key);
  @override
  _FieldsExercicioState createState() => _FieldsExercicioState();
}

class _FieldsExercicioState extends State<FieldsExercicio> {
  String? _selectedExercise;
  int _numOfSeries = 1;
  final _controllers = <TextEditingController>[];

  final _database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _numOfSeries; i++) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          StreamBuilder(
            stream: _database.ref('exercicios').onValue,
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
                child: Text(value.toString()),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                _numOfSeries = newValue!;
                _controllers.length = _numOfSeries;
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
              for (int i = 0; i < _numOfSeries; i++) {
                print(_controllers[i].text);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
