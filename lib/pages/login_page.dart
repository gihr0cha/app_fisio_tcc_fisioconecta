import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey =
      GlobalKey<FormState>(); // Chave do formulário para validação dos campos
  String? _email;
  String? _password;
  String? erroMessage;

  bool validateAndSave() {
    // O método validateAndSave verifica se o formulário é válido e salva os dados no estado do widget
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao validar o login'),
        ),
      );
      return false;
    }
  }

  void validateAndSubmit() async {
    // O método validateAndSubmit chama o método validateAndSave e, se o formulário for válido, faz login no Firebase Authentication
    try {
      if (validateAndSave()) {
        UserCredential user = await FirebaseAuth
            .instance // Faz login no Firebase Authentication
            .signInWithEmailAndPassword(
                email: _email!,
                password: _password!); // Email e senha do usuário para login
        ScaffoldMessenger(
            child: Text(
                'usuario logado: ${user.user!.uid}')); // Imprime o ID do usuário logado no console
        mounted
            ? context.go('/home')
            : null; // Navega para a página home se o widget estiver montado
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
          // Propaga o erro para o Flutter mostrar na tela
        }
      } else {
        erroMessage = 'Erro';
        // Propaga o erro para o Flutter mostrar na tela
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
        textColor: Colors.green,
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
              color: Colors.green,
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
                      TextFormField( // Estilo do campo de texto
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
                        
                        validator: (value) =>
                            value!.isEmpty ? 'Campo obrigatório' : null,
                        onSaved: (value) => _password = value,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha:',
                          hintText: 'Digite sua senha',
                        ),
                        cursorColor: Colors.blue,
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: double.maxFinite,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: validateAndSubmit,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          child: const Text(
                            'Entrar',
                            style: TextStyle(
                                color: Colors.green,
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
                                fontSize: 16, 
                                color: Colors.black,
                        
                                ),

                          ),
                          // O TextButton é um botão de texto que, quando pressionado, navega para a página de criação de conta
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
