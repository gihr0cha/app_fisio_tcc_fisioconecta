import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '/widgets/gerarpdf.dart';

class DetalhesSessaoPage extends StatefulWidget {
  final String sessaoKey;
  const DetalhesSessaoPage({super.key, required this.sessaoKey});

  @override
  _DetalhesSessaoPageState createState() => _DetalhesSessaoPageState();
}

class _DetalhesSessaoPageState extends State<DetalhesSessaoPage> {
  @override
  Widget build(BuildContext context) {
    final database = FirebaseDatabase.instance;
    final sessionRef = database.ref().child('sessoes').child(widget.sessaoKey);
    final sessaoKey = widget.sessaoKey;

    return Scaffold(
      appBar: AppBar(
        title: Text(sessaoKey),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: sessionRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            var session =
                Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
            var inicioSessao =
                Map<String, dynamic>.from(session['inicio_sessao'] as Map);
            var exercicios =
                Map<String, dynamic>.from(session['exercicios'] as Map);
            var finalSessao =
                Map<String, dynamic>.from(session['final_sessao'] as Map);
            return ListView(
              children: [
                ExpansionTile(
                  title: const Text('Início'),
                  children: [
                    ListTile(
                      title: Text(
                          'Paciente sentiu dor? ${inicioSessao['dor'] == true ? 'Sim' : 'Não'}'),
                    ),
                    ListTile(
                      title: Text(
                          'Frequência Cardíaca: ${inicioSessao['freqCardiacaInicial'].toString()}'),
                    ),
                    ListTile(
                      title: Text(
                          'Saturação Periférica de Oxigênio: ${inicioSessao['spo2Inicial'].toString()}'),
                    ),
                    ListTile(
                      title: Text(
                          'Pressão Arterial: ${inicioSessao['paInicial'].toString()}'),
                    ),
                    ListTile(
                      title: Text(
                          'Percepção Subjetiva de Esforço: ${inicioSessao['pseInicial'].toString()}'),
                    ),
                    ListTile(
                      title: Text(
                          'Dor Torácica: ${inicioSessao['dorToracicaInicial'].toString()}'),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text('Exercícios'),
                  children: [
                    for (var key in exercicios.keys)
                      ListTile(
                        title: Text(
                          '$key: series: ${exercicios[key]['repeticao'].join(', ')}',
                        ),
                      ),
                  ],
                ),
                ExpansionTile(
                  title: const Text('Final'),
                  children: [
                    ListTile(
                      title: Text(
                          'Frequência Cardíaca: ${finalSessao['freqCardiacaFinal'].toString()}'),
                    ),
                    ListTile(
                      title: Text(
                          'Saturação Periférica de Oxigênio: ${finalSessao['spo2Final'].toString()}'),
                    ),
                    ListTile(
                      title: Text(
                          'Pressão Arterial: ${finalSessao['paFinal'].toString()}'),
                    ),
                    ListTile(
                      title: Text(
                          'Percepção Subjetiva de Esforço: ${finalSessao['pseFinal'].toString()}'),
                    ),
                    ListTile(
                      title: Text(
                          'Dor Torácica: ${finalSessao['dorToracicaFinal'].toString()}'),
                    ),
                    ListTile(
                      title: Text(
                          'Comentarios: ${finalSessao['comentario'].toString()}'),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: () {
                    gerarECompartilharPDF(
                      sessaoKey,
                      [
                        {
                          'Início': inicioSessao,
                          'Exercícios': exercicios,
                          'Final': finalSessao,
                        }
                      ],
                    );
                  },
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
