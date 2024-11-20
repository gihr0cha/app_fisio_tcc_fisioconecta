import 'package:flutter/material.dart';
import '../logic/historico_logic.dart';
import '../widgets/detalhesessao.dart';

class HistoricoPage extends StatefulWidget {
  final dynamic paciente;

  const HistoricoPage({super.key, required this.paciente});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  final HistoricoLogic _logic = HistoricoLogic();

  @override
  Widget build(BuildContext context) {
    final fisio = _logic.getUserName();
    final paciente = widget.paciente;
    final filter = paciente['nome'];

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
                color: Colors.white,
              ),
            ),
            Text(
              'Olá, $fisio',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.white,
              ),
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
        stream: _logic.getSessoesStream(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
            Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
            Map<String, dynamic> formattedMap = _logic.formatDatabaseSnapshot(map);

            var filteredList = _logic.filterSessoes(formattedMap, filter);

            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  var sessaoEntry = filteredList[index];
                  String sessaoKey = sessaoEntry.key;
                  String dataSessao = sessaoKey.split(' ')[2];
                  String horaSessao = sessaoKey.split(' ')[3];

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
            return const Center(
              child: Text('Erro ao carregar dados'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
