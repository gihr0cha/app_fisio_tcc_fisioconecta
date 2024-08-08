import 'package:app_fisio_tcc/pages/filtrarevolucao.dart';

import 'pages/login_page.dart';
import 'package:flutter/material.dart';
import 'pages/createaccount_page.dart';
import 'pages/home_page.dart';
import 'pages/paciente_page.dart';
import 'pages/exercicios_page.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/registerPacients_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    runApp(const MyApp());
  } catch (e) {
    rethrow; // Propaga o erro para o Flutter mostrar na tela
  }
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
      routes: <RouteBase>[
        GoRoute(
            path: 'createAccount',
            builder: (BuildContext context, GoRouterState state) {
              return const CreateAccountPage();
            }),
        GoRoute(
            path: 'home',
            builder: (BuildContext context, GoRouterState state) {
              return const HomePage();
            }),
        GoRoute(
            path: 'pacientes',
            builder: (BuildContext context, GoRouterState state) {
              return const PacientePage();
            }),
        GoRoute(
            path: 'exercicios',
            builder: (BuildContext context, GoRouterState state) {
              return const ExerciciosPage();
            }),
        GoRoute(
            path: 'evolucao',
            builder: (BuildContext context, GoRouterState state) {
              return const FiltrarEvolucaoPage();
            }),
        GoRoute(
            path: 'registerPacients',
            builder: (BuildContext context, GoRouterState state) {
              return const RegisterPacients();
            })
      ])
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'My App',
    );
  }
}
