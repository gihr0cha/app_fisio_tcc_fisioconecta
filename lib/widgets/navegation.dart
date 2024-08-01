import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigacaoBar extends StatelessWidget {
  const NavigacaoBar({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ValueNotifier<int>(0); 
    // Valor inicial do índice selecionado na barra de navegação

    return ValueListenableBuilder<int>(
      // O ValueListenableBuilder é um widget que reconstrói a interface do usuário sempre que o valor do ValueListenable muda
      valueListenable: selectedIndex,
      builder: (context, value, child) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green[700],
          unselectedItemColor: Colors.green,
          currentIndex: value,
          onTap: (int index) {
            selectedIndex.value = index;
// Atualiza o índice selecionado na barra de navegação com o índice do item selecionado pelo usuário 
            switch (index) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.go('/pacientes');
                break;
              case 2:
                context.go('/exercicios');
                break;
              case 3:
                context.go('/evolucao');
                break;
            }
          },
          // Cria os itens da barra de navegação com ícones e rótulos para cada página da interface do usuário 
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Pacientes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Exercicios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              label: 'Evolução',
            ),
          ],
        );
      },
    );
  }
}
