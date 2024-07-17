import 'package:app_fisio_tcc/pages/editpaciente.dart';

import 'fieldsinicial.dart';
import 'navegation_page.dart';
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
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseDatabase database = FirebaseDatabase.instance;

    final fisio = user?.displayName ?? '';
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        title: Column(
          children: [
            const Text(
              'FisioConecta - Pacientes',
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
                  color: Color(0xFFFFFFFF)),
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RegisterPacients()));
        },
        backgroundColor: const Color(0xff4a9700),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: database.ref().child('pacientes').onValue,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot);
            if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
              Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
              Map<String, dynamic> formattedMap = {};
              print(snapshot);
              map.forEach((key, value) {
                formattedMap[key.toString()] = value;
              });

              return ListView.builder(
                itemCount: formattedMap.length,
                itemBuilder: (context, index) {
                  try {
                    var patientData = formattedMap.values.toList()[index];
                    String nome = patientData['nome'];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FieldsInicial(paciente: patientData)));
                      },
                      child: ListTile(
                        title: Text(nome),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
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
                    print(e);
                    return const ListTile(
                      title: Text('Erro'),
                      subtitle: Text('Nenhum dado cadastrado'),
                    );
                  }
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
      bottomNavigationBar: const NavigacaoBar(),
    );
  }
}
