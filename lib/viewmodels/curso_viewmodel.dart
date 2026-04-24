import 'package:flutter/material.dart';
import '../models/curso.dart';
import '../repository/curso_repository.dart';
import '../repository/academic_period_repository.dart';
import '../models/academic_period.dart';

class CursoViewModel extends ChangeNotifier {
  final CursoRepository repository;
  final AcademicPeriodRepository periodoRepository;

  bool loading = false;
  bool creating = false;
  List<Curso> cursos = [];
  AcademicPeriod? periodoActivo;
  String? errorPeriodo;

  CursoViewModel({
    required this.repository,
    required this.periodoRepository,
  });

  Future<void> loadCursos() async {
    loading = true;
    errorPeriodo = null;
    notifyListeners();

    // 1. Obtener periodo activo
    periodoActivo = await periodoRepository.getPeriodoActivo();

    if (periodoActivo == null) {
      errorPeriodo = 'No hay periodo académico activo. Crea uno primero.';
      cursos = [];
      loading = false;
      notifyListeners();
      return;
    }

    // 2. Cargar cursos del periodo activo
    cursos = await repository.getCursos(periodoActivo!.id!);
    loading = false;
    notifyListeners();
  }

   Future<bool> createCurso({
    required String nombre,
    required String nivel,
    String? descripcion,
  }) async {
    if (creating) return false;

    if (periodoActivo == null) {
      await loadCursos(); // 🔥 asegura periodo
      if (periodoActivo == null) return false;
    }

    creating = true;
    notifyListeners();

    try {
      final success = await repository.createCurso(
        periodoId: periodoActivo!.id!,
        nombre: nombre,
        nivel: nivel,
        descripcion: descripcion,
      );

      if (success) {
        await loadCursos();
      }

      return success;
    } finally {
      creating = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCurso(int id) async {
    if (periodoActivo == null) return false;

    loading = true;
    notifyListeners();

    final success = await repository.deleteCurso(periodoActivo!.id!, id);
    if (success) await loadCursos();

    loading = false;
    notifyListeners();
    return success;
  }
}