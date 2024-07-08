import 'package:app_fisio_tcc/assets/colors/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'navegation_page.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key, Key? paciente});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseDatabase database = FirebaseDatabase.instance;

    final fisio = user?.displayName ?? '';
    return Scaffold(
      backgroundColor: AppColors.green2,
      appBar: AppBar(
        backgroundColor: const Color(0xff4a9700),
        title: Column(
          children: [
            const Text(
              'FisioConecta - Histórico',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: AppColors.whiteApp),
            ),
            Text(
              'Olá, $fisio',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppColors.whiteApp),
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
                    String nome = patientData['nome'] ?? 'Nome não disponível';
                    String datanascimento = patientData['data_nascimento'] ??
                        'Data de nascimento não disponível';

                    return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HistoricoPage(
                                        paciente: Key(patientData['nome']),
                                      )));
                        },
                        child: ListTile(
                          title: Text(nome),
                          subtitle: Text(datanascimento),
                        ));
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
