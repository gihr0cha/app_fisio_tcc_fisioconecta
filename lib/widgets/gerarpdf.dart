import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> gerarECompartilharPDF(
    String sessaoKey, List<dynamic> dadosListView) async {
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
              child: pw.Text("Detalhes da Sessão: $sessaoKey",
                  style: const pw.TextStyle(fontSize: 18)),
            ),
            // Corpo do PDF
            for (var dados in dadosListView) _buildSessionDetails(dados),
          ],
        );
      },
    ));

    final bytes = await pdf.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'detalhes_sessao_$sessaoKey.pdf',
    );
  } on Exception catch (e) {
    print('Erro ao gerar PDF: $e');
    rethrow;
  }
}

/// Constrói os detalhes da sessão
pw.Widget _buildSessionDetails(Map<String, dynamic> dados) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      if (dados.containsKey('Início')) _buildInicioSection(dados['Início']),
      if (dados.containsKey('Exercícios'))
        _buildExerciciosSection(dados['Exercícios']),
      if (dados.containsKey('Final')) _buildFinalSection(dados['Final']),
    ],
  );
}

/// Constrói a seção "Início"
pw.Widget _buildInicioSection(Map<String, dynamic> inicio) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Header(
        level: 1,
        child: pw.Text("Início",
            style:
                const pw.TextStyle(fontSize: 16, color: PdfColors.blueAccent)),
      ),
      pw.Bullet(
          text:
              "Paciente sentiu dor? ${inicio['dor'] == true ? 'Sim' : 'Não'}"),
      pw.Bullet(text: "Dor Torácica: ${inicio['dorToracicaInicial']}"),
      pw.Bullet(text: "Frequência Cardíaca: ${inicio['freqCardiacaInicial']}"),
      pw.Bullet(text: "Pressão Arterial: ${inicio['paInicial']}"),
      pw.Bullet(
          text: "Percepção Subjetiva de Esforço: ${inicio['pseInicial']}"),
      pw.Bullet(
          text: "Saturação Periférica de Oxigênio: ${inicio['spo2Inicial']}"),
    ],
  );
}

/// Constrói a seção "Exercícios"
pw.Widget _buildExerciciosSection(Map<String, dynamic> exercicios) {
  final maxSeries = exercicios.values
      .map((e) => e['repeticao']?.length ?? 0)
      .reduce((a, b) => a > b ? a : b);

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Header(
        level: 1,
        child: pw.Text("Exercícios",
            style:
                const pw.TextStyle(fontSize: 16, color: PdfColors.blueAccent)),
      ),
      pw.Table(
        border: pw.TableBorder.all(),
        children: [
          // Cabeçalho da tabela
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text("Exercício",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              for (int i = 0; i < maxSeries; i++)
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text("Série ${i + 1}",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
            ],
          ),
          // Linhas de exercícios
          for (var entry in exercicios.entries)
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(entry.key),
                ),
                for (int i = 0; i < maxSeries; i++)
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      i < (entry.value['repeticao']?.length ?? 0)
                          ? entry.value['repeticao'][i].toString()
                          : '',
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
              ],
            ),
        ],
      ),
    ],
  );
}

/// Constrói a seção "Final"
pw.Widget _buildFinalSection(Map<String, dynamic> finalData) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Header(
        level: 1,
        child: pw.Text("Final",
            style:
                const pw.TextStyle(fontSize: 16, color: PdfColors.blueAccent)),
      ),
      pw.Bullet(text: "Dor Torácica: ${finalData['dorToracicaFinal']}"),
      pw.Bullet(
          text: "Frequência Cardíaca Final: ${finalData['freqCardiacaFinal']}"),
      pw.Bullet(text: "Pressão Arterial: ${finalData['paFinal']}"),
      pw.Bullet(
          text: "Percepção Subjetiva de Esforço: ${finalData['pseFinal']}"),
      pw.Bullet(
          text: "Saturação Periférica de Oxigênio: ${finalData['spo2Final']}"),
      if (finalData['comentario'] != null)
        pw.Text("Comentários: ${finalData['comentario']}"),
    ],
  );
}
