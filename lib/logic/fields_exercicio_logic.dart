import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FieldsExercicioLogic {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  String? selectedExercise;
  int numOfSeries = 1;
  late String sessionKey;
  List<TextEditingController> controllers = [];

  /// Inicializa a chave da sessão e controladores
  void initialize(String sessionKey) {
    this.sessionKey = sessionKey;
    controllers = List.generate(numOfSeries, (index) => TextEditingController());
  }

  /// Atualiza o exercício selecionado
  void updateSelectedExercise(String? exercise) {
    selectedExercise = exercise;
  }

  /// Atualiza o número de séries e recria os controladores
  void updateNumOfSeries(int newNum) {
    numOfSeries = newNum;
    controllers = List.generate(numOfSeries, (index) => TextEditingController());
  }

  /// Obtém o stream de exercícios disponíveis do Firebase
  Stream<DatabaseEvent> getExercisesStream() {
    return _database.ref('exercicios').onValue;
  }

  /// Salva os dados da sessão no Firebase
  Future<void> saveSession(BuildContext context) async {
    if (selectedExercise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um exercício!')),
      );
      return;
    }

    DatabaseReference sessionRef =
        _database.ref('sessoes').child(sessionKey).child('exercicios');

    List<String> repeticao = controllers.map((controller) => controller.text).toList();

    await sessionRef.update({
      selectedExercise!: {
        'repeticao': repeticao,
      },
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados salvos com sucesso!')),
    );

    resetState();
  }

  /// Reseta o estado interno após salvar
  void resetState() {
    selectedExercise = null;
    numOfSeries = 1;
    controllers = List.generate(numOfSeries, (index) => TextEditingController());
  }
}
