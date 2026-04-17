import 'package:flutter/material.dart';
import '../models/estudiante.dart';
import '../repository/estudiante_repository.dart';

class EstudianteViewModel extends ChangeNotifier {
  final EstudianteRepository repository;
  EstudianteViewModel({required this.repository});

  bool loading = false;
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
    loading = true;
    notifyListeners();
    final success = await repository.createEstudiante(
      name: name, email: email, password: password, codigo: codigo,
    );
    loading = false;
    if (success) await loadEstudiantes();
    notifyListeners();
    return success;
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