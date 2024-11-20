import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/createaccount_page.dart';
import 'pages/exercicios_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/paciente_page.dart';
import 'pages/filtrarevolucao.dart';
import 'pages/registerPacients_page.dart';

// Define os nomes das rotas como constantes
class RouteNames {
  static const String login = '/';
  static const String createAccount = '/createAccount';
  static const String home = '/home';
  static const String pacientes = '/pacientes';
  static const String exercicios = '/exercicios';
  static const String evolucao = '/evolucao';
  static const String registerPacients = '/registerPacients';
}

// Configura o roteamento principal
final GoRouter appRouter = GoRouter(routes: <RouteBase>[
  GoRoute(
    path: RouteNames.login,
    builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    routes: <RouteBase>[
      GoRoute(
        path: RouteNames.createAccount.substring(1),
        builder: (BuildContext context, GoRouterState state) => const CreateAccountPage(),
      ),
      GoRoute(
        path: RouteNames.home.substring(1),
        builder: (BuildContext context, GoRouterState state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.pacientes.substring(1),
        builder: (BuildContext context, GoRouterState state) => const PacientePage(),
      ),
      GoRoute(
        path: RouteNames.exercicios.substring(1),
        builder: (BuildContext context, GoRouterState state) => const ExerciciosPage(),
      ),
      GoRoute(
        path: RouteNames.evolucao.substring(1),
        builder: (BuildContext context, GoRouterState state) => const FiltrarEvolucaoPage(),
      ),
      GoRoute(
        path: RouteNames.registerPacients.substring(1),
        builder: (BuildContext context, GoRouterState state) => const RegisterPacients(),
      ),
    ],
  ),
]);
