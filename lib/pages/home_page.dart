import 'package:app_fisio_tcc/assets/colors/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'navegation_page.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final database = FirebaseDatabase.instance;
    final fisio =
        'fisioterapeutas/${FirebaseAuth.instance.currentUser!.displayName}';

    var nome = user?.displayName ?? '';
    nome = nome.split(' ')[0];

    var scaffold3 = Scaffold(
      backgroundColor: AppColors.green2,
      appBar: AppBar(
        backgroundColor: const Color(0xff4a9700),
        title: Column(
          children: [
            const Text(
              'FisioConecta - Home',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: AppColors.whiteApp),
            ),
            Text(
              'Olá, $nome!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppColors.whiteApp),
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
        onPressed: () {
          context.go('/registerPacients');
        },
        backgroundColor: const Color(0xff4a9700),
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: AppColors.whiteApp,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: StreamBuilder(
          stream: database.ref().child(fisio).onValue,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
              map = map.cast<String, dynamic>();
              if (map.isNotEmpty) {
                return ListView.builder(
                  itemCount: map.length,
                  itemBuilder: (context, index) {
                    var outerData = map.values.toList()[index];
                    var innerData = outerData.values.toList()[0];
                    String nome = innerData['nome'] ?? 'Sem nome';
                    String email = innerData['email'] ?? 'Sem email';
                    return ListTile(
                      title: Text(nome),
                      subtitle: Text(email),
                    );
                  },
                );
              } else {
                return const Center(
                    child: Text(
                        'A lista está vazia. Por favor, adicione um paciente.'));
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      bottomNavigationBar: const NavigacaoBar(),
    );
    var scaffold2 = scaffold3;
    var scaffold = scaffold2;
    return scaffold;
  }
}
