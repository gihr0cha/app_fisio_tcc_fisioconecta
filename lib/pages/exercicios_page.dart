import 'package:flutter/material.dart';
import '../logic/exercicios_logic.dart';
import '../widgets/criarexercicio.dart';
import '../widgets/navegation.dart';

class ExerciciosPage extends StatefulWidget {
  const ExerciciosPage({super.key});

  @override
  State<ExerciciosPage> createState() => _ExerciciosPageState();
}

class _ExerciciosPageState extends State<ExerciciosPage> {
  final ExerciciosLogic _logic = ExerciciosLogic();
  String filter = '';
  bool _isTextFieldVisible = false;

  @override
  Widget build(BuildContext context) {
    final fisio = _logic.getUserName();

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FisioConecta - Exercícios',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isTextFieldVisible = !_isTextFieldVisible;
                    });
                  },
                ),
              ],
            ),
            if (_isTextFieldVisible)
              TextField(
                onChanged: (value) {
                  setState(() {
                    filter = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Filtrar exercícios',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            Text(
              'Olá, $fisio',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.white),
            ),
          ],
        ),
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CriarExercicio()));
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _logic.getExerciciosStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
            Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
            Map<String, dynamic> formattedMap = _logic.formatDatabaseSnapshot(map);

            var filteredList = _logic.filterExercicios(formattedMap, filter);

            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  var exercicioData = filteredList[index];
                  String nome = exercicioData;
                  String key = formattedMap.keys.toList()[index];

                  return ListTile(
                    title: Text(nome, style: const TextStyle(color: Colors.white)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.white,
                      onPressed: () => _logic.deleteExercicio(key),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: const NavigacaoBar(currentIndex: 2),
    );
  }
}
