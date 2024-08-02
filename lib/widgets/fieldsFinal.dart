import 'package:app_fisio_tcc/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FieldsFinal extends StatefulWidget {
  final dynamic paciente; // Paciente
  final dynamic sessionKey; // Chave da sessão
  const FieldsFinal(
      {Key? key,
      required this.paciente,
      required this.sessionKey}) // Construtor
      : super(key: key); // Chama o construtor da superclasse

  @override
  _FieldsFinalState createState() => _FieldsFinalState();
}

class _FieldsFinalState extends State<FieldsFinal> {
  final user = FirebaseAuth.instance.currentUser; // Usuário atual
  final database = FirebaseDatabase.instance; // Instância do banco de dados
  final _formKey = GlobalKey<FormState>(); // Chave do formulário
  final _controller = PageController(); // Controlador de página
  dynamic paciente;
  dynamic sessionKey;

  final _fieldsfinal = const [
    // Lista de campos do formulário
    {
      'label': 'Frequência Cardíaca',
      'validator': 'Por favor, insira a frequência cardíaca final'
    },
    {'label': 'Saturação Periférica de Oxigênio', 'validator': 'Por favor, insira o SpO2 final'},
    {'label': 'Pressão Arterial', 'validator': 'Por favor, insira a PA final'},
    {'label': 'Percepção Subjetiva de Esforço', 'validator': 'Por favor, insira a PSE final'},
    {
      'label': 'Dor Torácica',
      'validator': 'Por favor, insira a dor torácica final'
    },
    {'label': 'Comentarios', 'validator': 'Por favor, insira um comentário'},
  ];

  Map<String, dynamic> healthParametersFinal = {
    // Parâmetros de saúde final
    'freqCardiacaFinal': null,
    'spo2Final': null,
    'paFinal': null,
    'pseFinal': null,
    'dorToracicaFinal': null,
    'comentario': null,
  };

  @override
  void initState() {
    super.initState(); // Inicializa o estado do widget
    paciente = widget.paciente; // Inicializa o paciente
    sessionKey = widget.sessionKey; // Inicializa a chave da sessão
  }

  bool validateAndSave() {
    // O método validateAndSave verifica se o formulário é válido e salva os dados no estado do widget
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao validar o formulário'),
        ),
      );
      return false;
    }
  }

  void validateAndSubmit() {
    // O método validateAndSubmit chama o método validateAndSave e, se o formulário for válido, atualiza os parâmetros de saúde final no banco de dados
    if (validateAndSave()) {
      DatabaseReference dbRef = database.ref();
      DatabaseReference sessionRef = dbRef
          .child('sessoes')
          .child(sessionKey); // Referência da sessão no banco de dados

      sessionRef.update({
        'final_sessao': healthParametersFinal,
      }); // Atualiza os parâmetros de saúde final no banco de dados com os dados inseridos pelo fisioterapeuta
      _controller.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    } // Navega para a próxima página do PageView
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        title: Text(
            'Formulário de Saúde: ${widget.paciente}'), // Título da barra de aplicativos
      ),
    
      body: Form(
        key: _formKey,
        child: PageView.builder(
          // Cria um PageView com um formulário para cada campo
          controller: _controller,
          itemCount: _fieldsfinal.length, // Número de páginas
          itemBuilder: (context, index) {
            // Cria um AlertDialog com um campo de texto para cada campo do formulário
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AlertDialog(
                backgroundColor: Colors.white,
                 // Título do AlertDialog
                content: TextFormField(
                  decoration:
                      InputDecoration(labelText: _fieldsfinal[index]['label']),
                  keyboardType: index == _fieldsfinal.length - 1
                      ? TextInputType.multiline
                      : TextInputType.number,
                  maxLines: index == _fieldsfinal.length - 1
                      ? null
                      : 1, // Define o tipo de teclado como numérico
                  validator: (value) {
                    // Valida o campo para garantir que não esteja vazio (exceto para o campo de comentários)
                    if (index != _fieldsfinal.length - 1 &&
                        (value == null || value.isEmpty)) {
                      return _fieldsfinal[index]['validator'];
                    }
                    return null; // Retorna null para indicar que não há erro
                  },
                  onChanged: (value) {
                    setState(() {
                      // Atualiza o estado do widget com os dados inseridos pelo fisioterapeuta
                      switch (index) {
                        case 0:
                          healthParametersFinal['freqCardiacaFinal'] = value;
                          break;
                        case 1:
                          healthParametersFinal['spo2Final'] = value;
                          break;
                        case 2:
                          healthParametersFinal['paFinal'] = value;
                          break;
                        case 3:
                          healthParametersFinal['pseFinal'] = value;
                          break;
                        case 4:
                          healthParametersFinal['dorToracicaFinal'] = value;
                          break;
                        case 5:
                          healthParametersFinal['comentario'] = value;
                          break;
                      }
                    });
                  },
                ),
                actions: [
                  if (index <
                      _fieldsfinal.length -
                          1) // Adiciona um botão 'Próximo' se não for a última página
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () => _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      ),
                      child: const Text('Próximo',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  if (index == _fieldsfinal.length - 1)
                    ElevatedButton(
                      
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        validateAndSubmit(); // Adiciona um botão 'Enviar' se for a última página

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processando Dados')),
                        );

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HomePage())); // Volta para HomePage após enviar os dados
                      },
                      child: const Text('Enviar', style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
