import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../assets/theme_app.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  String? _name;
  String? erroMessage;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );
        await userCredential.user!.updateDisplayName(_name);
        context.go('/home');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          erroMessage = 'A senha fornecida é muito fraca';
        } else if (e.code == 'email-already-in-use') {
          erroMessage = 'Esse e-mail já está em uso';
        } else {
          erroMessage = 'Erro desconhecido';
        }
        mensagem(context, erroMessage);
      } catch (e) {
        erroMessage = 'Erro desconhecido';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.greenApp, AppColors.gradienteBaixo],
              ),
            ),
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
                          validator: (value) =>
                              value!.isEmpty ? 'Campo obrigatório' : null,
                          onSaved: (value) => _name = value,
                          textInputAction: TextInputAction.next,
                          style: AppTheme
                              .themeData.inputDecorationTheme.labelStyle,
                          decoration: const InputDecoration(
                            hintText: 'Digite seu nome',
                            labelText: 'Nome:',
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Campo obrigatório' : null,
                          onSaved: (value) => _email = value,
                          textInputAction: TextInputAction.next,
                          style: AppTheme
                              .themeData.inputDecorationTheme.labelStyle,
                          decoration: const InputDecoration(
                            hintText: 'Digite seu email',
                            labelText: 'E-mail:',
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Campo obrigatório' : null,
                          onSaved: (value) => _password = value,
                          textInputAction: TextInputAction.next,
                          style: AppTheme
                              .themeData.inputDecorationTheme.labelStyle,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Digite sua senha',
                            labelText: 'Senha:',
                          ),
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
                              'Cadastrar',
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
                              'Já possui uma conta?',
                              style: TextStyle(
                                  fontSize: 16, color: AppColors.greyApp),
                            ),
                            TextButton(
                              onPressed: () => context.go('/'),
                              child: const Text(
                                'Entre!',
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
          ),
        ],
      ),
    );
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
}
