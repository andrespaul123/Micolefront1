import 'package:flutter/material.dart';
import '../models/estudiante.dart';
import '../repository/estudiante_repository.dart';

class EstudianteViewModel extends ChangeNotifier {
  final EstudianteRepository repository;
  EstudianteViewModel({required this.repository});

  bool loading = false;
  bool creating = false;
  List<Estudiante> estudiantes = [];

  Future<void> loadEstudiantes() async {
    loading = true;
    notifyListeners();
    estudiantes = await repository.getEstudiantes();
    loading = false;
    notifyListeners();
  }

  Future<bool> createEstudiante({
    required String name,
    required String email,
    required String password,
    required String codigo,
  }) async {
    if (creating) return false; 

    creating = true;
    notifyListeners();

    try{
      final success = await repository.createEstudiante(
        name: name,
        email: email,
        password: password,
        codigo: codigo,
      );

      if (success) {
        await loadEstudiantes(); 
      }

      return success;
    } finally {
      creating = false;
      notifyListeners();
    }

  }

  Future<bool> deleteEstudiante(int id) async {
    loading = true;
    notifyListeners();
    final success = await repository.deleteEstudiante(id);
    if (success) await loadEstudiantes();
    loading = false;
    notifyListeners();
    return success;
  }
}