import 'package:firebase_database/firebase_database.dart';
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
    // acessa o estado atual do formulário e valida os campos
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
// A função validateAndSubmit valida os campos do formulário e, se estiverem corretos, cria um novo usuário no Firebase Authentication e salva os dados do fisioterapeuta no Firebase Realtime Database
  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email!,
        password: _password!,

      );
      await userCredential.user!.updateDisplayName(_name);
      
      // Salva os dados do fisioterapeuta no Firebase Realtime Database
      final personalizarId = '${_email!.split('@')[0]}_${userCredential.user!.uid}';
      DatabaseReference dbRef = FirebaseDatabase.instance.ref();
      dbRef.child('fisioterapeutas').child(personalizarId).set({
        'nome': _name,
        'pacientes': {}  // Inicialmente, o fisioterapeuta não tem pacientes associados
      });
        if (mounted) {
          context.go('/home');
        }
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
            // O SingleChildScrollView permite que o conteúdo da tela seja rolável
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
                        // O TextFormField de nome é um campo de texto que pode ser validado e salvo
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
                        // O TextFormField de email é um campo de texto que pode ser validado e salvo
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
                        // O TextFormField de senha é um campo de texto que pode ser validado e salvo
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
                        // O ElevatedButton é um botão que, quando pressionado, chama a função validateAndSubmit
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
// A função mensagem exibe uma mensagem de erro na tela
  void mensagem(BuildContext context, String? erroMessage) {
    if (mounted) {
      final snackBar = SnackBar(
        content: Text(erroMessage!),
        action: SnackBarAction(
          label: 'Fechar',
          onPressed: () {
            if (mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          },
        ),
      );
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    }
  }
}
