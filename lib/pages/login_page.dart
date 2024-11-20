import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_fisio_tcc/logic/login_logic.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginLogic _logic = LoginLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.green),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? 'lib/assets/images/LogoFisioConecta.png'
                    : 'lib/assets/images/LogoFisioConectaBranco.png',
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Text(
                  'Gerenciamento de pacientes para fisioterapeutas.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Form(
                key: _logic.formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? 'Campo obrigatório' : null,
                        onSaved: (value) => _logic.email = value,
                        decoration: const InputDecoration(
                          labelText: 'E-mail:',
                          hintText: 'Digite seu email',
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? 'Campo obrigatório' : null,
                        onSaved: (value) => _logic.password = value,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha:',
                          hintText: 'Digite sua senha',
                        ),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => _logic.validateAndSubmit(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Entrar',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Não possui uma conta?',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          TextButton(
                            onPressed: () => context.go('/createAccount'),
                            child: const Text(
                              'Clique aqui!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
