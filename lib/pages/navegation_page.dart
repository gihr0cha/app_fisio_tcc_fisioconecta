import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigacaoBar extends StatelessWidget {
  const NavigacaoBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: const Color(0xFF4CAF50),
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
            icon: Icon(Icons.history),
            label: 'Historico',
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            context.go('/home');
          }
          if (index == 1) {
            context.go('/pacientes');
          }
          if (index == 2) {
            context.go('/exercicios');
          }
          if (index == 3) {
            context.go('/historico');
          }
        });
  }
}
