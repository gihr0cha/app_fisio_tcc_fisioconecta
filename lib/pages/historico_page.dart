import 'package:app_fisio_tcc/pages/detalhesessao.dart';
import 'package:app_fisio_tcc/pages/navegation_page.dart';
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

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Histórico de Sessões'),
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

            return ListView.builder(
              itemCount: sessoes.length, // Número de sessões disponíveis
              itemBuilder: (context, index) {
                var sessaoData = sessoes[index]; // Dados da sessão
                String sessaoKey = sessaoData['key']; // Chave da sessão
               

                String nomePaciente = sessaoKey.split(
                    ' ')[0]; 
                String dataSessao = sessaoKey.split(
                    ' ')[2];
                // Simplificação, considera apenas o primeiro nome e a data da sessão

                return ListTile(
                  title: Text(
                    'Sessão com $nomePaciente',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Data: $dataSessao',
                    style: const TextStyle(
                      color: Colors.white,
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
