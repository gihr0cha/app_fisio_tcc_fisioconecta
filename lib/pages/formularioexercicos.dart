import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FormularioExercicios extends StatefulWidget {
  const FormularioExercicios({Key? key}) : super(key: key);

  @override
  _FormularioExercicosState createState() => _FormularioExercicosState();
}

class _FormularioExercicosState extends State<FormularioExercicios> {
  String? _selectedExercise;
  int _numOfSeries = 1;
  List<TextEditingController> _controllers = [TextEditingController()];

  final FirebaseDatabase _database = FirebaseDatabase.instance;

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.green,
    body: Column(
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
              child: Text('$value séries'),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              _numOfSeries = newValue!;
              _controllers =
                  List.generate(_numOfSeries, (index) => TextEditingController());
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
                    labelText: 'Número de repetições para a série ${index + 1}',
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
              _database.ref('exercicios').child(_selectedExercise!).update({
                'series':
                    _controllers.map((controller) => controller.text).toList(),
              });
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    ),
  );
  }
}