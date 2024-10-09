import 'package:app_fisio_tcc/widgets/checkBoxFED.dart';
import 'package:app_fisio_tcc/widgets/editpaciente.dart';
import 'package:app_fisio_tcc/widgets/navegation.dart';
import 'registerPacients_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PacientePage extends StatefulWidget {
  const PacientePage({super.key, Key? paciente});

  @override
  State<PacientePage> createState() => _PacientePageState();
}

class _PacientePageState extends State<PacientePage> {
  String filter = ''; // Variável para armazenar o texto de pesquisa
  bool _isTextFieldVisible = false; // Variável para controlar a visibilidade

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseDatabase database = FirebaseDatabase.instance;

    final fisio = (user?.displayName ?? '').split(' ')[0];
    final fisioId = user?.uid;
    // Variável para armazenar o nome do fisioterapeuta logado

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cabeçalho do AppBar com o nome do aplicativo e um ícone de pesquisa
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FisioConecta - Pacientes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  // Ícone de pesquisa que ao ser clicado altera a visibilidade do TextField
                  onPressed: () {
                    setState(() {
                      _isTextFieldVisible =
                          !_isTextFieldVisible; // Toggle visibility
                    });
                  },
                ),
              ],
            ),
            if (_isTextFieldVisible) // Conditionally render the TextField
              TextField(
                onChanged: (value) {
                  setState(() {
                    filter = value;

                    // Update the filter variable
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Filtrar por nome',
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
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RegisterPacients()));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: database.ref().child('pacientes').onValue,
          // O StreamBuilder é usado para ouvir as mudanças no banco de dados Firebase Realtime Database
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
              Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
              Map<String, dynamic> formattedMap = {};

              map.forEach((key, value) {
                formattedMap[key.toString()] = value;
              });

              var filteredList = formattedMap.values
                  .where((patient) =>
                      patient['nome']
                          .toString()
                          .toLowerCase()
                          .contains(filter.toLowerCase()) &&
                      patient['fisioId'] == fisioId)
                  .toList();

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
                    try {
                      var patientData = filteredList[index];
                      String nome = patientData['nome'];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                 CheckBoxFED(paciente: patientData),
                            ),
                          );
                        },
                        child: ListTile(
                          leading:
                              const Icon(Icons.person, color: Colors.white),
                          title: Text(nome,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white)),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blueAccent),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditPaciente(
                                          pacienteData: patientData)));
                            },
                          ),
                        ),
                      );
                    } catch (e) {
                      showAboutDialog(
                          context: context, applicationName: 'Erro');
                      return const ListTile(
                        title: Text('Erro'),
                        subtitle: Text('Nenhum dado cadastrado'),
                      );
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
