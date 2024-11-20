import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../logic/create_account_logic.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final CreateAccountLogic _logic = CreateAccountLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.green),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 240,
                  margin: const EdgeInsets.only(top: 150),
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.light
                        ? 'lib/assets/images/LogoFisioConecta.png'
                        : 'lib/assets/images/LogoFisioConectaBranco.png',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Text(
                    'Gerenciamento de pacientes para fisioterapeutas.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
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
                          onSaved: (value) => _logic.name = value,
                          decoration: const InputDecoration(
                            hintText: 'Digite seu nome',
                            labelText: 'Nome:',
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Campo obrigatório' : null,
                          onSaved: (value) => _logic.email = value,
                          decoration: const InputDecoration(
                            hintText: 'Digite seu email',
                            labelText: 'E-mail:',
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Campo obrigatório' : null,
                          onSaved: (value) => _logic.password = value,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Digite sua senha',
                            labelText: 'Senha:',
                          ),
                          textInputAction: TextInputAction.done,
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
                              'Cadastrar',
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
                              'Já possui uma conta?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/'),
                              child: const Text(
                                'Entre!',
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
          ),
        ],
      ),
    );
  }
}
