import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


Future<void> gerarECompartilharPDF(String sessaoKey, List<dynamic> dadosListView)
  async {

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
                      style: const pw.TextStyle(fontSize: 18))),
              // Corpo do PDF com uma função de loop para iterar sobre os dados
              for (var dados in dadosListView)
                for (var key in dados.keys)
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Início
                      pw.Header(
                          level: 1,
                          child: pw.Text("Início",
                              style: const pw.TextStyle(
                                  fontSize: 16, color: PdfColors.blue))),
                      pw.Bullet(
                          text:
                              "Paciente sentiu dor? ${dados['Início']['dor'] == true ? 'Sim' : 'Não'}"),
                      pw.Bullet(
                          text:
                              "Dor Torácica: ${dados['Início']['dorToracicaInicial']}"),
                      pw.Bullet(
                          text:
                              "Frequência Cardíaca: ${dados['Início']['freqCardiacaInicial']}"),
                      pw.Bullet(
                          text:
                              "Pressão Arterial: ${dados['Início']['paInicial']}"),
                      pw.Bullet(
                          text:
                              "Percepção Subjetiva de Esforço: ${dados['Início']['pseInicial']}"),
                      pw.Bullet(
                          text:
                              "Saturação Periférica de Oxigênio: ${dados['Início']['spo2Inicial']}"),

                      // Exercícios
                      pw.Header(
                        level: 1,
                        child: pw.Text("Exercícios",
                            style: const pw.TextStyle(
                                fontSize: 16, color: PdfColors.blue)),
                      ),
                      pw.Table(
                        border: pw.TableBorder.all(),
                        columnWidths: <int, pw.TableColumnWidth>{
                          0: const pw.FlexColumnWidth(),
                          1: const pw.FixedColumnWidth(100),
                        },
                        children: [
                          // Cabeçalho da tabela de exercícios
                          pw.TableRow(
                            children: [
                              // Adicionando nome do exercício
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text(
                                  'Exercício',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.center,
                                ),
                              ),
                              // Encontrar o maior número de séries entre todos os exercícios
                              for (int i = 0;
                                  i <
                                      dados['Exercícios']
                                          .values
                                          .map((e) => e['repeticao'].length)
                                          .reduce((a, b) => a > b ? a : b);
                                  i++)
                                pw.Padding(
                                  // Adicionando o número da série
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(
                                    'Série: ${i + 1}',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),
                            ],
                          ),

                          // Adicionando linhas de exercícios após o cabeçalho
                          for (var exercicio in dados['Exercícios'].keys)
                            pw.TableRow(
                              children: [
                                // Adicionando nome do exercício
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(exercicio),
                                ),
                                // Adicionando séries de pesos para cada exercício
                                for (int i = 0;
                                    i <
                                        dados['Exercícios']
                                            .values
                                            .map((e) => e['repeticao'].length)
                                            .reduce((a, b) => a > b ? a : b);
                                    i++)
                                  // Adicionando o peso da série
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.all(5),
                                    // Verificando se a série de pesos existe para o exercício
                                    child: pw.Text(
                                      i <
                                              dados['Exercícios'][exercicio]
                                                      ['repeticao']
                                                  .length
                                          ? dados['Exercícios'][exercicio]
                                                  ['repeticao'][i]
                                              .toString()
                                          : ' ',
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),

                      // Final
                      pw.Header(
                          level: 1,
                          child: pw.Text("Final",
                              style: const pw.TextStyle(
                                  fontSize: 16, color: PdfColors.blue))),
                      pw.Bullet(
                          text:
                              "Dor Torácica: ${dados['Final']['dorToracicaFinal']}"),
                      pw.Bullet(
                          text:
                              "Frequência Cardíaca Final: ${dados['Final']['freqCardiacaFinal']}"),
                      pw.Bullet(
                          text:
                              "Pressão Arterial: ${dados['Final']['paFinal']}"),
                      pw.Bullet(
                          text:
                              "Percepção Subjetiva de Esforço: ${dados['Final']['pseFinal']}"),
                      pw.Bullet(
                          text:
                              "Saturação Periférica de Oxigênio: ${dados['Final']['spo2Final']}"),
                      pw.Annotation(
                        child: pw.Text(
                            "Comentários: ${dados['Final']['comentario']}"),
                      )
                    ],
                  ),
            ],
          );
        },
      ));
      final bytes = await pdf.save();
      await Printing.sharePdf(
          bytes: bytes, filename: 'detalhes_sessao_$sessaoKey.pdf');
    } on Exception catch (e) {
      print(e);
    }
  }