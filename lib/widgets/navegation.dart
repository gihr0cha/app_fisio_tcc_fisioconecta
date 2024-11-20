import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigacaoBar extends StatelessWidget {
  final int currentIndex;

  const NavigacaoBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.green,
      currentIndex: currentIndex,
      onTap: (int index) {
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
          label: 'Exercícios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          label: 'Evolução',
        ),
      ],
    );
  }
}
