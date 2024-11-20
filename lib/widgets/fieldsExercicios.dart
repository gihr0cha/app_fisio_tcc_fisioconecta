import 'package:flutter/material.dart';
import '../logic/fields_exercicio_logic.dart';
import '../pages/fields_final_page.dart';

class FieldsExercicio extends StatefulWidget {
  final dynamic paciente;
  final dynamic sessionKey;

  const FieldsExercicio({super.key, required this.paciente, required this.sessionKey});

  @override
  _FieldsExercicioState createState() => _FieldsExercicioState();
}

class _FieldsExercicioState extends State<FieldsExercicio> {
  final FieldsExercicioLogic _logic = FieldsExercicioLogic();

  @override
  void initState() {
    super.initState();
    _logic.initialize(widget.sessionKey);
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
        title: const Text('Exercícios'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            StreamBuilder(
              stream: _logic.getExercisesStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
                  var exercises = Map<String, String>.from(
                      (snapshot.data!.snapshot.value as Map<dynamic, dynamic>)
                          .map((key, value) => MapEntry(key.toString(), value.toString())));

                  return DropdownButton<String>(
                    value: _logic.selectedExercise,
                    hint: const Text('Selecione um exercício'),
                    items: exercises.values
                        .map((value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _logic.updateSelectedExercise(newValue);
                      });
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            DropdownButton<int>(
              value: _logic.numOfSeries,
              items: [1, 2, 3, 4, 5]
                  .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value série(s)'),
                      ))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _logic.updateNumOfSeries(newValue!);
                });
              },
            ),
            for (int i = 0; i < _logic.numOfSeries; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _logic.controllers[i],
                  decoration: InputDecoration(
                    labelText: 'Número de repetições ${i + 1}',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () async {
                await _logic.saveSession(context);
                setState(() {}); // Atualiza o estado após salvar
              },
              child: const Text('Adicionar exercício', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () async {
                await _logic.saveSession(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FieldsFinal(
                      paciente: widget.paciente,
                      sessionKey: widget.sessionKey,
                    ),
                  ),
                );
              },
              child: const Text('Salvar e continuar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
