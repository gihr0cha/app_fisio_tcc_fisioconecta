import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../assets/theme_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  String? erroMessage;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      print("Form is valid");
      form.save();
      return true;
    } else {
      print("Form is invalid");
      return false;
    }
  }

  void validateAndSubmit() async {
    try {
      if (validateAndSave()) {
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email!, password: _password!);
        print("Usuário logado: ${user.user!.uid}");
        context.go('/home');
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case "user-not-found":
            erroMessage = 'Nenhum usuário encontrado';
            break;
          case "wrong-password":
            erroMessage = 'Senha errada';
            break;
          default:
            erroMessage = 'Erro';
            print(e);
        }
      } else {
        erroMessage = 'Erro';
        print(e);
      }
      mensagem(context, erroMessage);
    }
  }

  void mensagem(BuildContext context, String? erroMessage) {
    final snackBar = SnackBar(
      content: Text(erroMessage!),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.greenApp, AppColors.gradienteBaixo],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? 'lib/assets/images/LogoFisioConecta.png'
                    : 'lib/assets/images/LogoFisioConectaBranco.png',
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 0,
                  bottom: 32,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Gerenciamento de pacientes para fisioterapeutas.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                  child: Column(
                    children: [
                      TextFormField(
                        style:
                            AppTheme.themeData.inputDecorationTheme.labelStyle,
                        validator: (value) =>
                            value!.isEmpty ? 'Campo obrigatório' : null,
                        onSaved: (value) => _email = value,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'E-mail:',
                          hintText: 'Digite seu email',
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        style:
                            AppTheme.themeData.inputDecorationTheme.labelStyle,
                        validator: (value) =>
                            value!.isEmpty ? 'Campo obrigatório' : null,
                        onSaved: (value) => _password = value,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha:',
                          hintText: 'Digite sua senha',
                        ),
                        cursorColor: AppColors.greyApp,
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: double.maxFinite,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: validateAndSubmit,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.whiteApp,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          child: const Text(
                            'Entrar',
                            style: TextStyle(
                                color: AppColors.greenApp,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Não possui uma conta?',
                            style: TextStyle(
                                fontSize: 16, color: AppColors.greyApp),
                          ),
                          TextButton(
                            onPressed: () => context.go('/createAccount'),
                            child: const Text(
                              'Clique aqui!',
                              style: TextStyle(
                                color: AppColors.greyApp,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
