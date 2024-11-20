import 'package:app_fisio_tcc/widgets/fieldsExercicios.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../logic/firebase_utils.dart'; 

class FieldsInicial extends StatefulWidget {
  final dynamic paciente;
  final List<Map<String, dynamic>> selectedFields;
  const FieldsInicial(
      {super.key,
      required this.selectedFields,
      required this.paciente}); // Construtor

  @override
  _FieldsInicialState createState() => _FieldsInicialState();
}

class _FieldsInicialState extends State<FieldsInicial> {
  final user = FirebaseAuth.instance.currentUser;
  final database = FirebaseDatabase.instance; // Instância do banco de dados
  final _formKey = GlobalKey<FormState>(); // Chave do formulário
  final _controller = PageController(); // Controlador de página


  @override
  void initState() {
    super.initState();
     // Inicializa o paciente
  }


  void validateAndSubmit() {
    // O método validateAndSubmit chama o método validateAndSave e, se o formulário for válido, cria um novo nó no banco de dados Firebase Realtime Database para a sessão
    if (FormUtils.validateAndSave(_formKey, context)) {
      DatabaseReference dbRef = database.ref();
      DateTime now = DateTime.now(); // Data e hora atuais
      String formattedDate =
          "${now.day}-${now.month}-${now.year}--${now.hour}:${now.minute}";
      String customKey =
          "${widget.paciente['nome']}-$formattedDate"; // Chave personalizada para a sessão com o nome do paciente e a data e hora atuais

      DatabaseReference newSessionRef = dbRef.child('sessoes').child(customKey);
      newSessionRef.set({
        'inicio_sessao': widget.selectedFields
            .map((field) => field['label'] + ': ' + field['value'])
            .toList(),
      }); // Cria um novo nó para a sessão com os parâmetros de saúde inicial inseridos pelo fisioterapeuta

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
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        title: Text(
            'Formulário de Saúde: ${widget.paciente['nome']}'), // Título da barra de aplicativos com o nome do paciente
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Form(
          key: _formKey,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.selectedFields
                .length, // Número de páginas do PageView igual ao número de campos do formulário
            itemBuilder: (context, index) {
              return buildField(context,
                  index); // Cria um AlertDialog com um campo de texto para cada campo do formulário
            },
          ),
        ),
      ),
    );
  }

   Widget buildField(BuildContext context, int index) {
    final field = widget.selectedFields[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        backgroundColor: Colors.white,
        content: TextFormField(
          decoration: InputDecoration(labelText: field['label']),
          keyboardType: TextInputType.number, // Define o tipo de teclado como numérico
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, preencha este campo'; // Valida o campo para garantir que não esteja vazio
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              field['value'] = value; // Atualiza o valor do campo
            });
          },
        ),
        actions: [
          // Adiciona um botão 'Próximo' se não for a última página e um botão 'Enviar' se for a última página
          if (index < widget.selectedFields.length - 1)
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
          if (index == widget.selectedFields.length - 1)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Valida o formulário antes de enviar
                  validateAndSubmit(); // Adiciona um botão 'Enviar' se for a última página
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Processando Dados')), // Exibe uma mensagem de processamento de dados
                  );
                }
              },
              child: const Text('Enviar', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
        ],
      ),
    );
  }
}