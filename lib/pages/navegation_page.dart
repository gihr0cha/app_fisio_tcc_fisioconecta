import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigacaoBar extends StatelessWidget {
  const NavigacaoBar({super.key});

  @override
  Widget build(BuildContext context) {
    final _selectedIndex = ValueNotifier<int>(0);

    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndex,
      builder: (context, value, child) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green[700],
          unselectedItemColor: Colors.green[700],
          currentIndex: value,
          onTap: (int index) {
            _selectedIndex.value = index;

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
                context.go('/historico');
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
              label: 'Exercicios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Historico',
            ),
          ],
        );
      },
    );
  }
}
