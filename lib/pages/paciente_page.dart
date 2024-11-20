import 'package:flutter/material.dart';
import '../logic/paciente_logic.dart';
import '../widgets/checkBoxFED.dart';
import '../widgets/editpaciente.dart';
import '../widgets/navegation.dart';
import 'registerPacients_page.dart';

class PacientePage extends StatefulWidget {
  const PacientePage({super.key});

  @override
  State<PacientePage> createState() => _PacientePageState();
}

class _PacientePageState extends State<PacientePage> {
  final PacienteLogic _logic = PacienteLogic();
  String filter = '';
  bool _isTextFieldVisible = false;

  @override
  Widget build(BuildContext context) {
    final fisio = _logic.getUserName();
    final fisioId = _logic.getFisioId();

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FisioConecta - Pacientes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isTextFieldVisible = !_isTextFieldVisible;
                    });
                  },
                ),
              ],
            ),
            if (_isTextFieldVisible)
              TextField(
                onChanged: (value) {
                  setState(() {
                    filter = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Filtrar por nome',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            Text(
              'Olá, $fisio',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.white),
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
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPacients()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _logic.getPacientesStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
            Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
            Map<String, dynamic> formattedMap = _logic.formatDatabaseSnapshot(map);

            var filteredList =
                _logic.filterPacientes(formattedMap, filter, fisioId);

            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  var patientData = filteredList[index];
                  String nome = patientData['nome'];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CheckBoxFED(paciente: patientData),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.white),
                      title: Text(nome,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white)),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit,
                            color: Colors.green),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPaciente(
                                pacienteData: patientData,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: const NavigacaoBar(),
    );
  }
}
