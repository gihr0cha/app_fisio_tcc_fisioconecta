import 'package:app_fisio_tcc/pages/fieldsExercicios.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FieldsInicial extends StatefulWidget {
  final dynamic paciente;
  const FieldsInicial({Key? key, required this.paciente}) : super(key: key); // Construtor 

  @override
  _FieldsInicialState createState() => _FieldsInicialState();
}

class _FieldsInicialState extends State<FieldsInicial> {
  final user = FirebaseAuth.instance.currentUser; 
  final database = FirebaseDatabase.instance; // Instância do banco de dados
  final _formKey = GlobalKey<FormState>(); // Chave do formulário 
  final _controller = PageController(); // Controlador de página 
  dynamic paciente; 

  final _fieldsinicial = const [
    // Lista de campos do formulário 
    {'label': 'Dor', 'validator': 'Paciente apresenta dor?'}, 
    {
      'label': 'Frequência Cardíaca',
      'validator': 'Por favor, insira a frequência cardíaca inicial'
    },
    {'label': 'SpO2', 'validator': 'Por favor, insira o SpO2 inicial'},
    {'label': 'PA', 'validator': 'Por favor, insira a PA inicial'},
    {'label': 'PSE', 'validator': 'Por favor, insira a PSE inicial'},
    {
      'label': 'Dor Torácica',
      'validator': 'Por favor, insira a dor torácica inicial'
    },
  ];

  Map<String, dynamic> healthParametersinicial = {
    // Parâmetros de saúde inicial onde os valores são nulos para serem preenchidos pelo fisioterapeuta
    'dor': false, 
    'freqCardiacaInicial': null,
    'spo2Inicial': null,
    'paInicial': null,
    'pseInicial': null,
    'dorToracicaInicial': null,
  };

  @override
  void initState() {
    super.initState();
    paciente = widget.paciente; // Inicializa o paciente 
  }

  bool validateAndSave() {
    final form = _formKey.currentState; 
    // O método validateAndSave verifica se o formulário é válido e salva os dados no estado do widget
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      print('Formulário não salvo');
      return false;
    }
  }

  void validateAndSubmit() { 
    // O método validateAndSubmit chama o método validateAndSave e, se o formulário for válido, cria um novo nó no banco de dados Firebase Realtime Database para a sessão
    if (validateAndSave()) {
      DatabaseReference dbRef = database.ref();
      DateTime now = DateTime.now(); // Data e hora atuais
      String formattedDate =
          "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}";
      String customKey = "${widget.paciente['nome']} $formattedDate"; // Chave personalizada para a sessão com o nome do paciente e a data e hora atuais

      DatabaseReference newSessionRef = dbRef.child('sessoes').child(customKey);
      newSessionRef.set({
        'inicio_sessao': healthParametersinicial
      }); // Cria um novo nó para a sessão com os parâmetros de saúde inicial inseridos pelo fisioterapeuta

      print(database);

      // Navega para a próxima página do PageView onde o fisioterapeuta pode inserir os exercícios
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FieldsExercicio(
            sessionKey: customKey,
            paciente: widget.paciente['nome'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Saúde: ${widget.paciente['nome']}'), // Título da barra de aplicativos com o nome do paciente
      ),
      body: Form(
        key: _formKey,
        child: PageView.builder(
          controller: _controller,
          itemCount: _fieldsinicial.length, // Número de páginas do PageView igual ao número de campos do formulário
          itemBuilder: (context, index) {
            return buildField(context, index); // Cria um AlertDialog com um campo de texto para cada campo do formulário
          },
        ),
      ),
    );
  }

  
  
Widget buildField(BuildContext context, int index) {
  if (index == 0) { // Caso específico para o índice 0 (dor)
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CheckboxListTile(
            title: const Text('Paciente apresenta dor?'),
            value: healthParametersinicial['dor'],
            onChanged: (bool? value) {
              setState(() {
                healthParametersinicial['dor'] = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () => _controller.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
            child: const Text('Próximo'),
          ),
        ],
      ),
    );
  } else { // Para os outros índices, mantém o comportamento anterior
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        content: TextFormField(
          decoration: InputDecoration(labelText: _fieldsinicial[index]['label']),
          keyboardType: TextInputType.number, // Define o tipo de teclado como numérico
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _fieldsinicial[index]['validator']; // Valida o campo para garantir que não esteja vazio
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              switch (index) {
                // Atualiza o estado do widget com os dados inseridos pelo fisioterapeuta para cada campo do formulário 
                case 1:
                  healthParametersinicial['freqCardiacaInicial'] = value;
                  break;
                case 2:
                  healthParametersinicial['spo2Inicial'] = value;
                  break;
                case 3:
                  healthParametersinicial['paInicial'] = value;
                  break;
                case 4:
                  healthParametersinicial['pseInicial'] = value;
                  break;
                case 5:
                  healthParametersinicial['dorToracicaInicial'] = value;
                  break;
              }
            });
          },
        ),
        actions: [ // Adiciona um botão 'Próximo' se não for a última página e um botão 'Enviar' se for a última página
          if (index < _fieldsinicial.length - 1)
            ElevatedButton(
              onPressed: () => _controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              ),
              child: const Text('Próximo'),
            ),
          if (index == _fieldsinicial.length - 1)
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) { // Valida o formulário antes de enviar
                  validateAndSubmit(); // Adiciona um botão 'Enviar' se for a última página
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processando Dados')), // Exibe uma mensagem de processamento de dados
                  );
                }
              },
              child: const Text('Enviar'),
            ),
        ],
      ),
    );
  }
}
}

