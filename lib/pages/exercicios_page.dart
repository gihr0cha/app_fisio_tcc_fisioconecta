import 'package:app_fisio_tcc/widgets/criarexercicio.dart';
import 'package:app_fisio_tcc/widgets/navegation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ExerciciosPage extends StatefulWidget {
  const ExerciciosPage({super.key});

  @override
  State<ExerciciosPage> createState() => _ExerciciosPageState();
}

class _ExerciciosPageState extends State<ExerciciosPage> {
  String filter = ''; // Variável para armazenar o texto de pesquisa
  bool _isTextFieldVisible = false;
  // Variável para controlar a visibilidade do TextField

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseDatabase database = FirebaseDatabase.instance;

    final fisio = user?.displayName ?? '';

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        // O AppBar é usado para exibir o cabeçalho da página
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FisioConecta - Exercicios',
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
                      _isTextFieldVisible =
                          !_isTextFieldVisible; // Toggle visibility
                    });
                  },
                ),
              ],
            ),
            if (_isTextFieldVisible)
              // O TextField é usado para permitir que o usuário pesquise exercícios
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
          // O StreamBuilder é usado para ouvir as mudanças no banco de dados Firebase Realtime Database
          stream: database.ref('exercicios').onValue,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
              // O snapshot.data.snapshot.value contém os dados do nó 'exercicios' no banco de dados Firebase Realtime Database
              Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
              Map<String, dynamic> formattedMap = {};
              map.forEach((key, value) {
                formattedMap[key.toString()] = value;
              });
              // O ListView.builder é usado para exibir a lista de exercícios
              
              var filteredList = formattedMap.values
                  .where((exercicio) => exercicio.toString()
                      .toLowerCase()
                      .contains(filter.toLowerCase()))
                  .toList();

              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: ListView.builder(
                  
                  shrinkWrap: true,
                  // O shrinkWrap é definido como true para que o ListView se ajuste ao tamanho do conteúdo
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    try {
                      // O nome do exercício é obtido do mapa formatado e exibido em um ListTile
                      var exercicioData = filteredList[index];
                      String nome = exercicioData;
                      String key =
                          formattedMap.keys.toList()[index]; // Chave do exercício
                
                      return ListTile(
                          title: Text(nome),
                          trailing: IconButton(
                            // O IconButton é usado para exibir um ícone de exclusão ao lado do exercício
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Remove o exercício do banco de dados Firebase Realtime Database
                              database.ref('exercicios/$key').remove();
                            },
                          ));
                    } catch (e) {
                      
                      return ScaffoldMessenger(child: Text(e.toString()));
                      
                    }
                  },
                ),
              );
            } else {
              return const CircularProgressIndicator();
              
            }
          }),
      bottomNavigationBar: const NavigacaoBar(),
    );
  }
}
