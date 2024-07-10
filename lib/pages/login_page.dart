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
  final formKey = GlobalKey<FormState>(); // Chave do formulário para validação dos campos
  String? _email; 
  String? _password;
  String? erroMessage; 

  bool validateAndSave() {
    // O método validateAndSave verifica se o formulário é válido e salva os dados no estado do widget
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
    // O método validateAndSubmit chama o método validateAndSave e, se o formulário for válido, faz login no Firebase Authentication
    try {
      if (validateAndSave()) {
        UserCredential user = await FirebaseAuth.instance // Faz login no Firebase Authentication
            .signInWithEmailAndPassword(email: _email!, password: _password!); // Email e senha do usuário para login
        print("Usuário logado: ${user.user!.uid}"); // Imprime o ID do usuário logado no console
        context.go('/home');
      }
    } catch (e) {
      if (e is FirebaseAuthException) { 
        // Verifica se a exceção é do tipo FirebaseAuthException e exibe uma mensagem de erro adequada
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
    // O método mensagem exibe uma mensagem de erro na tela usando um SnackBar com um botão para fechar
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
        alignment: FractionalOffset.center,
        // O widget Stack permite empilhar widgets uns sobre os outros 
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                key: formKey, // Chave do formulário para validação dos campos
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                  child: Column(
                    children: [
                      // O TextFormField é um campo de texto que valida o email inserido pelo usuário
                      TextFormField(
                        style:
                            AppTheme.themeData.inputDecorationTheme.labelStyle, // Estilo do campo de texto
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
                      // O TextFormField é um campo de texto que valida a senha inserida pelo usuário
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
                          // O TextButton é um botão de texto que, quando pressionado, navega para a página de criação de conta
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
