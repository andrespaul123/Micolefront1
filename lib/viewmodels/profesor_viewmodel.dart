import 'package:flutter/material.dart';
import '../models/profesor.dart';
import '../repository/profesor_repository.dart';
import '../models/subject.dart';

class ProfesorViewModel extends ChangeNotifier {
  final ProfesorRepository repository;

  bool loading = false;
  bool creating = false;
  bool assigning = false;
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
  List<Subject> subjectsProfesor = [];

  Future<void> loadSubjectsProfesor(int profesorId) async {
  loading = true;
  notifyListeners();

  subjectsProfesor = await repository.getSubjectsByProfesor(profesorId);

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
    if (creating) return false;

    creating = true;
    notifyListeners();

    try {
      final success = await repository.createProfesor(
        name: name,
        email: email,
        password: password,
        codigo: codigo,
        especialidad: especialidad,
      );

      if (success) {
        await loadProfesores();
      }

      return success;
    } finally {
      creating = false;
      notifyListeners();
    }
  }
   Future<bool> asignarMateria({
    required int profesorId,
    required int subjectId,
  }) async {
    if (assigning) return false;

    assigning = true;
    notifyListeners();

    try {
      final success = await repository.asignarMateria(
        profesorId: profesorId,
        subjectId: subjectId,
      );

      // ❌ NO recargamos toda la lista (como padres)
      return success;
    } finally {
      assigning = false;
      notifyListeners();
    }
  }
Future<bool> deleteProfesor(int id) async {
    loading = true;
    notifyListeners();

    final success = await repository.deleteProfesor(id);

    if (success) await loadProfesores();

    loading = false;
    notifyListeners();
    return success;
  }
  
}