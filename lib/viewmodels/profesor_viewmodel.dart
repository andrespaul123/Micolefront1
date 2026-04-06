import 'package:flutter/material.dart';
import '../models/profesor.dart';
import '../repository/profesor_repository.dart';

class ProfesorViewModel extends ChangeNotifier {
  final ProfesorRepository repository;

  bool loading = false;
  List<Profesor> profesores = [];

  ProfesorViewModel({required this.repository});

  // LISTAR
  Future<void> loadProfesores() async {
    loading = true;
    notifyListeners();

    profesores = await repository.getProfesores();

    loading = false;
    notifyListeners();
  }

  // CREAR
  Future<bool> createProfesor({
    required String name,
    required String email,
    required String password,
    required String codigo,
    String? especialidad,
  }) async {
    loading = true;
    notifyListeners();

    final success = await repository.createProfesor(
      name: name,
      email: email,
      password: password,
      codigo: codigo,
      especialidad: especialidad,
    );

    loading = false;

    if (success) {
      await loadProfesores(); // 🔥 recargar
      return true;
    }

    notifyListeners();
    return false;
  }
  Future<bool> asignarMateria({
  required int profesorId,
  required int subjectId,
}) async {
  loading = true;
  notifyListeners();

  final success = await repository.asignarMateria(
    profesorId: profesorId,
    subjectId: subjectId,
  );

  loading = false;
  notifyListeners();

  return success;
}
}