import 'package:flutter/material.dart';
import '../models/curso.dart';
import '../repository/curso_repository.dart';

class CursoViewModel extends ChangeNotifier {
  final CursoRepository repository;

  bool loading = false;
  List<Curso> cursos = [];

  CursoViewModel({required this.repository});

  Future<void> loadCursos() async {
    loading = true;
    notifyListeners();

    cursos = await repository.getCursos();

    loading = false;
    notifyListeners();
  }

  Future<bool> createCurso({
    required String nombre,
    required String nivel,
    String? descripcion,
  }) async {
    loading = true;
    notifyListeners();

    final success = await repository.createCurso(
      nombre: nombre,
      nivel: nivel,
      descripcion: descripcion,
    );

    loading = false;

    if (success) {
      await loadCursos();
      return true;
    }

    notifyListeners();
    return false;
  }

  Future<bool> deleteCurso(int id) async {
    loading = true;
    notifyListeners();

    final success = await repository.deleteCurso(id);

    if (success) await loadCursos();

    loading = false;
    notifyListeners();
    return success;
  }
}