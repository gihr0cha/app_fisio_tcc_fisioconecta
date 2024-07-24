import 'package:app_fisio_tcc/widgets/fieldsFinal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldsExercicio extends StatefulWidget {
  final dynamic paciente;
  final dynamic sessionKey;

  const FieldsExercicio(
      {Key? key,
      required this.paciente,
      required this.sessionKey}) // Construtor
      : super(key: key);

  @override
  _FieldsExercicioState createState() => _FieldsExercicioState();
}

class _FieldsExercicioState extends State<FieldsExercicio> {
  String? _selectedExercise; // Exercício selecionado
  int _numOfSeries = 1; // Número de séries
  var _controllers =
      <TextEditingController>[]; // Lista de controladores de texto
  late String sessionKey; // Chave da sessão
  final _database = FirebaseDatabase.instance; // Instância do banco de dados

  @override
  void initState() {
    super.initState();
    sessionKey = widget.sessionKey; // Inicializa a chave da sessão
    for (int i = 0; i < _numOfSeries; i++) {
      _controllers.add(
          TextEditingController()); // Adiciona controladores de texto à lista
    }
  }

// O método validateAndSave verifica se o exercício foi selecionado e salva os dados da sessão no banco de dados
  validateAndSave() {
    if (_selectedExercise != null) {
      DatabaseReference dbRef = _database.ref();
      DatabaseReference sessionRef =
          dbRef.child('sessoes').child(sessionKey).child('exercicios');

      List<String> repeticao = []; // Lista de pesos
      for (int i = 0; i < _numOfSeries; i++) {
        repeticao.add(_controllers[i].text); // Adiciona o peso da série à lista
      }
// O método update atualiza o nó do exercício com o número de séries e os pesos inseridos pelo fisioterapeuta
      sessionRef.update({
        _selectedExercise.toString(): {
          'repeticao': repeticao,
        },
      });

      // Limpar os campos de texto e redefinir o exercício selecionado e o número de séries
      _selectedExercise = null;
      _numOfSeries = 1;
      for (var controller in _controllers) {
        controller.clear();
      }
      _controllers.length =
          _numOfSeries; // Redefine o tamanho da lista de controladores

      print('Dados salvos com sucesso!');
    } else {
      print('Por favor, selecione um exercício.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      backgroundColor: Colors.green,
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          StreamBuilder(
            stream: _database
                .ref('exercicios')
                .onValue, // Ouve as mudanças no nó 'exercicios' no banco de dados
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              // Cria um widget DropdownButton com os exercícios disponíveis
              // Verifica se há dados disponíveis e se o snapshot não é nulo
              if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
                Map<dynamic, dynamic> map = snapshot.data!.snapshot.value;
                Map<String, String> formattedMap = {};
                map.forEach((key, value) {
                  formattedMap[key.toString()] = value.toString();
                });
                // Retorna um DropdownButton com os exercícios disponíveis
                return DropdownButton<String>(
                  value: _selectedExercise,
                  hint: const Text('Selecione um exercício'),
                  items: formattedMap.values
                      .toList()
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      // Retorna um DropdownMenuItem com o valor do exercício
                      value: value,
                      child: Text(value),
                    );
                  }).toList(), // Converte a lista de valores em uma lista de DropdownMenuItems
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedExercise = newValue;
                    });
                  },
                );
              } else {
                print(snapshot);
                return const CircularProgressIndicator(); // Retorna um indicador de progresso se não houver dados disponíveis
              }
            },
          ),

          DropdownButton<int>(
            value: _numOfSeries,
            // Cria um DropdownButton com o número de séries
            items: [1, 2, 3, 4, 5].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value série(s)'),
              );
            }).toList(),
            // Atualiza o número de séries selecionado e a lista de controladores de texto
            onChanged: (int? newValue) {
              setState(() {
                _numOfSeries = newValue!;
                _controllers = List.generate(_numOfSeries, (index) {
                  return TextEditingController();
                  // controller é um objeto que controla um campo de texto
                });
              });
            },
          ),
          // Cria um campo de texto para cada série e um botão para salvar os dados da sessão
          for (int i = 0; i < _numOfSeries; i++)
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _controllers[i],
              decoration: InputDecoration(
                labelText: 'Numero de repetições ${i + 1}',
              ),
            ),
          ElevatedButton(
            onPressed: () {
              print(_selectedExercise);
              print(_numOfSeries);

              // Ensure _controllers has enough elements
              while (_controllers.length < _numOfSeries) {
                _controllers.add(TextEditingController(
                  text: _controllers[_controllers.length - 1].text,
                ));
              }

              for (int i = 0; i < _numOfSeries; i++) {
                print(_controllers[i].text);
              }
              validateAndSave();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dados salvos com sucesso!')),
              );
            },
            child: const Text('Adicionar exercicio'),
          ),
          // Navega para a página FieldsFinal ao pressionar o botão Continuar e passa os dados do paciente e a chave da sessão
          ElevatedButton(
            onPressed: () {
              validateAndSave();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dados salvos com sucesso!')),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FieldsFinal(
                    paciente: widget.paciente,
                    sessionKey: sessionKey,
                  ),
                ),
              );
            },
            child: const Text('Salvar e continuar'),
          ),
        ],
      ),
    );
    return scaffold;
  }
}
