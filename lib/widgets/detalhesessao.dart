import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../logic/detalhes_sessao_logic.dart';
import '../widgets/gerarpdf.dart';

class DetalhesSessaoPage extends StatefulWidget {
  final String sessaoKey;

  const DetalhesSessaoPage({super.key, required this.sessaoKey});

  @override
  State<DetalhesSessaoPage> createState() => _DetalhesSessaoPageState();
}

class _DetalhesSessaoPageState extends State<DetalhesSessaoPage> {
  final DetalhesSessaoLogic _logic = DetalhesSessaoLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sessaoKey),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _logic.getSessaoStream(widget.sessaoKey),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            var session = _logic.parseSnapshot(snapshot.data!);
            var inicioSessao = Map<String, dynamic>.from(session['inicio_sessao']);
            var exercicios = Map<String, dynamic>.from(session['exercicios']);
            var finalSessao = Map<String, dynamic>.from(session['final_sessao']);

            return ListView(
              children: [
                _buildExpansionTile('Início', [
                  _buildListTile('Paciente sentiu dor?',
                      inicioSessao['dor'] == true ? 'Sim' : 'Não'),
                  _buildListTile('Frequência Cardíaca',
                      inicioSessao['freqCardiacaInicial'].toString()),
                  _buildListTile('Saturação Periférica de Oxigênio',
                      inicioSessao['spo2Inicial'].toString()),
                  _buildListTile('Pressão Arterial',
                      inicioSessao['paInicial'].toString()),
                  _buildListTile('Percepção Subjetiva de Esforço',
                      inicioSessao['pseInicial'].toString()),
                  _buildListTile('Dor Torácica',
                      inicioSessao['dorToracicaInicial'].toString()),
                ]),
                _buildExpansionTile(
                  'Exercícios',
                  exercicios.entries
                      .map((entry) => _buildListTile(
                            entry.key,
                            'séries: ${entry.value['series']} - repetições: ${entry.value['repeticao']}',
                          ))
                      .toList(),
                ),
                _buildExpansionTile('Final', [
                  _buildListTile('Frequência Cardíaca',
                      finalSessao['freqCardiacaFinal'].toString()),
                  _buildListTile('Saturação Periférica de Oxigênio',
                      finalSessao['spo2Final'].toString()),
                  _buildListTile('Pressão Arterial',
                      finalSessao['paFinal'].toString()),
                  _buildListTile('Percepção Subjetiva de Esforço',
                      finalSessao['pseFinal'].toString()),
                  _buildListTile('Dor Torácica',
                      finalSessao['dorToracicaFinal'].toString()),
                  if (finalSessao['comentario'] != null)
                    _buildListTile('Comentários', finalSessao['comentario']),
                ]),
                IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: () {
                    gerarECompartilharPDF(
                      widget.sessaoKey,
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

  Widget _buildExpansionTile(String title, List<Widget> children) {
    return ExpansionTile(
      title: Text(title),
      children: children,
    );
  }

  Widget _buildListTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
