import 'package:app_fisio_tcc/widgets/detalhesessao.dart';
import 'package:app_fisio_tcc/widgets/navegation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HistoricoPage extends StatefulWidget {
  final dynamic paciente;
  const HistoricoPage({super.key, required this.paciente});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseDatabase database = FirebaseDatabase.instance;
    final user = FirebaseAuth.instance.currentUser; // Usuário logado
    final fisio = (user?.displayName ?? '').split(' ')[0]; // Variável para armazenar o nome do fisioterapeuta logado
    final paciente = widget.paciente; // Dados do paciente
    final filter = paciente['nome']; // Use o nome do paciente como filtro

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blueAccent,
        title: Column(
          children: [
            Text(
              'Evolução - $filter',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: Colors.white),
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
      body: StreamBuilder(
        stream: database.ref().child('sessoes').onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
            Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
            Map<String, dynamic> formattedMap = {};
            map.forEach((key, value) {
              formattedMap[key.toString()] = value;
            });

            var filteredList = formattedMap.entries
                .where((entry) => entry.key
                    .toString()
                    .toLowerCase()
                    .contains(filter.toLowerCase()))
                .toList();

            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredList.length, // Número de sessões disponíveis
                itemBuilder: (context, index) {
                  var sessaoEntry = filteredList[index]; // Dados da sessão
                  String sessaoFilter = sessaoEntry.key; // Chave da sessão
                  String dataSessao = sessaoFilter.split(' ')[2];
                  String horaSessao = sessaoFilter.split(' ')[3]; // Data da sessão

                  return ListTile(
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Colors.green,
                    ),
                    title: Text(
                      'Data: $dataSessao',
                      style: const TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    subtitle: Text(
                      horaSessao,
                      style: const TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesSessaoPage(
                            sessaoKey: sessaoFilter,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('Erro ao carregar dados');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}