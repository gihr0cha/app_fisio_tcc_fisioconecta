import 'package:app_fisio_tcc/assets/colors/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/navegation.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final nome = (user?.displayName ?? '').split(' ')[0];

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    icon: const Icon(Icons.logout),
                    color: AppColors.whiteApp),
                const SizedBox(width: 10),
                const Text(
                  'FisioConecta - Home',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: AppColors.whiteApp),
                ),
              ],
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
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo ao FisioConecta!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: AppColors.greenApp),
            ),
            SizedBox(height: 20),
            Text(
              'Esse é um aplicativo móvel desenvolvido para auxiliar fisioterapeutas no preenchimento e acompanhamento da Ficha de Evolução Diária (FED) de seus pacientes. Criado por Giovana de Oliveira Rocha e Ruan Mateus de Souza Nunes, o aplicativo visa resolver problemas comuns enfrentados pelos profissionais de saúde, como a falta de disponibilidade de sistemas de registro online no local de tratamento e a necessidade de transferir manualmente informações de papel para o sistema digital',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppColors.greenApp),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavigacaoBar(),
    );
  }
}
