import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
                          'Paciente sentiu dor: ${inicioSessao['dor'] == true ? 'Sim' : 'Não'}'),
                    ),
                    ListTile(
                      title: Text(
                          'Frequência Cardíaca: ${inicioSessao['freqCardiacaInicial'].toString()}'),
                    ),
                    ListTile(
                      title: Text(
                          'SpO2: ${inicioSessao['spo2Inicial'].toString()}'),
                    ),
                    ListTile(
                      title:
                          Text('PA: ${inicioSessao['paInicial'].toString()}'),
                    ),
                    ListTile(
                      title:
                          Text('PSE: ${inicioSessao['pseInicial'].toString()}'),
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
                          '$key: pesos: ${exercicios[key]['weights'].join(', ')}',
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
                      title:
                          Text('SpO2: ${finalSessao['spo2Final'].toString()}'),
                    ),
                    ListTile(
                      title: Text('PA: ${finalSessao['paFinal'].toString()}'),
                    ),
                    ListTile(
                      title: Text('PSE: ${finalSessao['pseFinal'].toString()}'),
                    ),
                    ListTile(
                      title: Text(
                          'Dor Torácica: ${finalSessao['dorToracicaFinal'].toString()}'),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: () {
                    gerarECompartilharPDF([
                      {
                        'Início': inicioSessao,
                        'Exercícios': exercicios,
                        'Final': finalSessao,
                      }
                    ]);
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

  Future<void> gerarECompartilharPDF(List<dynamic> dadosListView) async {
    try {
      final pdf = pw.Document();
      

      pdf.addPage(pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Cabeçalho do PDF
              pw.Header(
                  level: 0,
                  child: pw.Text("Detalhes da Sessão",
                      style: const pw.TextStyle(fontSize: 18))),
              // Corpo do PDF com uma função de loop para iterar sobre os dados
              for (var dados in dadosListView)
                for (var key in dados.keys)
                  pw.Column(
                    children: [
                      pw.Header(
                          level: 1,
                          child: pw.Text(key,
                              style: const pw.TextStyle(
                                  fontSize: 16, color: PdfColors.blue))),
                      for (var subKey in dados[key].keys)
                        pw.Bullet(
                            text: "$subKey: ${dados[key][subKey].toString()}"),
                    ],
                  ),
            ],
          );
        },
      ));
      final bytes = await pdf.save();
      await Printing.sharePdf(
          bytes: bytes, filename: 'detalhes_sessao_${widget.sessaoKey}.pdf');
    } on Exception catch (e) {
      print(e);
    }
  }
}
