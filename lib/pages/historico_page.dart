import 'package:app_fisio_tcc/widgets/detalhesessao.dart';
import 'package:app_fisio_tcc/widgets/navegation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseDatabase database = FirebaseDatabase.instance;
    final user = FirebaseAuth.instance.currentUser;
    final fisio = (user?.displayName ?? '').split(' ')[0];
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        title: Column(
          children: [
            const Text(
              'FisioConecta - Histórico',
              textAlign: TextAlign.center,
              style: TextStyle(
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
            List<dynamic> sessoes = map.entries.map((entry) {
              // Mapeia os dados da sessão para uma lista
              return {
                "key": entry.key,
                ...entry.value,
              }; // Retorna a chave e os valores da sessão
            }).toList();

            

            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: sessoes.length, // Número de sessões disponíveis
                itemBuilder: (context, index) {
                  var sessaoData = sessoes[index]; // Dados da sessão
                  String sessaoKey = sessaoData['key']; // Chave da sessão
              
                  String nomePaciente =
                      '${sessaoKey.split(' ')[0]} ${sessaoKey.split(' ')[1]}';
                  String dataSessao = sessaoKey.split(' ')[2];
                  // Simplificação, considera apenas o primeiro nome e a data da sessão
              
              
                  return ListTile(
                    title: Text(
                      'Sessão com $nomePaciente',
                      style: const TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    subtitle: Text(
                      'Data: $dataSessao',
                      style: const TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesSessaoPage(
                            sessaoKey: sessaoKey,
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
      bottomNavigationBar: const NavigacaoBar(),
    );
    
  }


}
