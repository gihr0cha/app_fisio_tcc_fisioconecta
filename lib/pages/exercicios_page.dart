import 'package:app_fisio_tcc/pages/criarexercicio.dart';
import 'package:app_fisio_tcc/pages/navegation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ExerciciosPage extends StatefulWidget {
  const ExerciciosPage({super.key});

  @override
  State<ExerciciosPage> createState() => _ExerciciosPageState();
}

class _ExerciciosPageState extends State<ExerciciosPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseDatabase database = FirebaseDatabase.instance;

    final fisio = user?.displayName ?? '';

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Column(
          children: [
            const Text(
              'FisioConecta - Exercicios',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: Colors.grey),
            ),
            Text(
              'Olá, $fisio',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.grey),
            ),
          ],
        ),
        toolbarHeight: 72,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CriarExercicio()));
        },
        backgroundColor: const Color(0xff4a9700),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: database.ref('exercicios').onValue,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
              Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
              List<dynamic> exerciciosList = map.values.toList();

              return ListView.builder(
                itemCount: exerciciosList.length,
                itemBuilder: (context, index) {
                  try {
                    var exercicioData = exerciciosList[index];
                    String nome = exercicioData;
                    return ListTile(
                      /* trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            database.ref('exercicios').child(nome).remove();
                          },
                        ), */
                      title: Text(nome),
                    );
                  } catch (e) {
                    print(e);
                    return const SizedBox
                        .shrink(); // Return an empty widget if there's an error
                  }
                },
              );
            } else {
              print(snapshot);
              return const CircularProgressIndicator();
            }
          }),
      bottomNavigationBar: const NavigacaoBar(),
    );
  }
}
