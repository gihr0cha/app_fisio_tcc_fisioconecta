import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:google_fonts/google_fonts.dart';

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
    try {
      final pdf = pw.Document();
      // Load the font data
      final fontData =
          await rootBundle.load('assets/fonts/OpenSans-Regular.ttf');
      // Correctly create a font from the ByteData
      final ttf = pw.Font.ttf(fontData.buffer.asByteData());

      final database = FirebaseDatabase.instance;
      final sessionRef =
          database.ref().child('sessoes').child(widget.sessaoKey);
      final snapshot = await sessionRef.once();
      final inicioSessao =
          Map<String, dynamic>.from(snapshot.snapshot.value as Map);

      pdf.addPage(
        pw.MultiPage(
          build: (context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  "Detalhes da Sessão",
                  style: pw.TextStyle(font: ttf),
                ),
              ),
              pw.Paragraph(
                text: "Sessão: ${widget.sessaoKey}",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Paragraph(
                text: "Início da Sessão:",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Bullet(
                text:
                    "Paciente sentiu dor: ${inicioSessao['dor'] == true ? 'Sim' : 'Não'}",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Bullet(
                text:
                    "Frequência Cardíaca: ${inicioSessao['freqCardiacaInicial'].toString()}",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Bullet(
                text: "SpO2: ${inicioSessao['spo2Inicial'].toString()}",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Bullet(
                text: "PA: ${inicioSessao['paInicial'].toString()}",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Bullet(
                text: "PSE: ${inicioSessao['pseInicial'].toString()}",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Bullet(
                text:
                    "Dor Torácica: ${inicioSessao['dorToracicaInicial'].toString()}",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Paragraph(
                text: "Exercícios:",
                style: pw.TextStyle(font: ttf),
              ),
              for (var key in inicioSessao['exercicios'].keys)
                pw.Bullet(
                  text:
                      "$key: pesos: ${inicioSessao['exercicios'][key]['weights'].join(', ')}",
                  style: pw.TextStyle(font: ttf),
                ),
              pw.Paragraph(
                text: "Final da Sessão:",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Bullet(
                text:
                    "Frequência Cardíaca: ${inicioSessao['freqCardiacaFinal'].toString()}",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Bullet(
                text: "SpO2: ${inicioSessao['spo2Final'].toString()}",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Bullet(
                text: "PA: ${inicioSessao['paFinal'].toString()}",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Bullet(
                text: "PSE: ${inicioSessao['pseFinal'].toString()}",
                style: pw.TextStyle(font: ttf),
              ),
              pw.Bullet(
                text:
                    "Dor Torácica: ${inicioSessao['dorToracicaFinal'].toString()}",
                style: pw.TextStyle(font: ttf),
              ),
            ];
          },
        ),
      );

      final file = File('detalhes_sessao${widget.sessaoKey}.pdf');
      await file.writeAsBytes(await pdf.save());
    } catch (e) {
      print(e);
    }
  }
}