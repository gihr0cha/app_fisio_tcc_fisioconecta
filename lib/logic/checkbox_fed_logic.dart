class CheckBoxFEDLogic {
  final List<Map<String, dynamic>> availableFields = [
    {'label': 'Frequência Cardíaca', 'selected': false},
    {'label': 'SPO2', 'selected': false},
    {'label': 'Pressão Arterial', 'selected': false},
    {'label': 'Percepção Subjetiva de Esforço', 'selected': false},
    {'label': 'Dor', 'selected': false},
  ];

  /// Atualiza o estado do campo selecionado
  void onFieldSelected(bool? selected, int index) {
    availableFields[index]['selected'] = selected;
  }

  /// Retorna os campos selecionados
  List<Map<String, dynamic>> getSelectedFields() {
    return availableFields.where((field) => field['selected']).toList();
  }
}
