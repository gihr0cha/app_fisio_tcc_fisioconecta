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
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              gerarECompartilharPDF();
            },
          ),
        ],
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
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

Future<void> gerarECompartilharPDF() async {
    final pdf = pw.Document();
    final database = FirebaseDatabase.instance;
    final sessionRef = database.ref().child('sessoes').child(widget.sessaoKey);
    final snapshot = await sessionRef.once();
    final inicioSessao = Map<String, dynamic>.from(snapshot.snapshot.value as Map);

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Header(level: 0, child: pw.Text("Detalhes da Sessão")),
            pw.Paragraph(text: "Sessão: ${widget.sessaoKey}"),
            pw.Paragraph(text: "Início da Sessão:"),

            pw.Bullet(text: "Paciente sentiu dor: ${inicioSessao['dor'] == true ? 'Sim' : 'Não'}"),
            pw.Bullet(text: "Frequência Cardíaca: ${inicioSessao['freqCardiacaInicial'].toString()}"),
            pw.Bullet(text: "SpO2: ${inicioSessao['spo2Inicial'].toString()}"),
            pw.Bullet(text: "PA: ${inicioSessao['paInicial'].toString()}"),
            pw.Bullet(text: "PSE: ${inicioSessao['pseInicial'].toString()}"),
            pw.Bullet(text: "Dor Torácica: ${inicioSessao['dorToracicaInicial'].toString()}"),

            pw.Paragraph(text: "Exercícios:"),
            for (var key in inicioSessao['exercicios'].keys)
              pw.Bullet(text: "$key: pesos: ${inicioSessao['exercicios'][key]['weights'].join(', ')}"),
          pw.Paragraph(text: "Final da Sessão:"),
          pw.Bullet(text: "Frequência Cardíaca: ${inicioSessao['freqCardiacaFinal'].toString()}"),
          pw.Bullet(text: "SpO2: ${inicioSessao['spo2Final'].toString()}"),
          pw.Bullet(text: "PA: ${inicioSessao['paFinal'].toString()}"),
          pw.Bullet(text: "PSE: ${inicioSessao['pseFinal'].toString()}"),
          pw.Bullet(text: "Dor Torácica: ${inicioSessao['dorToracicaFinal'].toString()}"),

          ];

          
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'detalhes_sessao.pdf');
  }
}