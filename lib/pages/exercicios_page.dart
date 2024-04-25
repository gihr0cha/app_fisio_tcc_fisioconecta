import 'package:app_fisio_tcc/assets/colors/colors.dart';
import 'package:app_fisio_tcc/repositories/procedimentos_reepository.dart';
import 'package:flutter/material.dart';
import 'navegation_page.dart';

class ExerciciosPage extends StatefulWidget {
  const ExerciciosPage({super.key});

  @override
  State<ExerciciosPage> createState() => _ExerciciosPageState();
}

class _ExerciciosPageState extends State<ExerciciosPage> {
  @override
  Widget build(BuildContext context) {
    final tabela = ProcedimeentosRepository.tabela;

    return Scaffold(
      backgroundColor: AppColors.green2,
      appBar: AppBar(
        backgroundColor: const Color(0xff4a9700),
        title: const Column(
          children: [
            Text(
              'FisioConecta ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: AppColors.whiteApp),
            ),
            Text(
              'Exercícios/Procedimentos',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: AppColors.whiteApp),
            ),
          ],
        ),
        toolbarHeight: 80,
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
          color: AppColors.whiteApp,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: ListView.separated(
            itemBuilder: (BuildContext context, int procedimentos) {
              return ListTile(
                leading: SizedBox(
                  width: 40,
                  child: Image.asset(tabela[procedimentos].icone),
                ),
                title: Text(
                  tabela[procedimentos].nome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: tabela.length),
      ),
      bottomNavigationBar: const NavigacaoBar(),
    );
  }
}
