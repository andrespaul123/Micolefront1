import 'package:flutter/material.dart';
import '../models/academic_period.dart';
import '../repository/academic_period_repository.dart';

class AcademicPeriodViewModel extends ChangeNotifier {
  final AcademicPeriodRepository repository;

  bool loading = false;
  List<AcademicPeriod> periodos = [];
  AcademicPeriod? periodoActivo;
  String? error;

  AcademicPeriodViewModel({required this.repository});

  Future<void> loadPeriodos() async {
    loading = true;
    notifyListeners();
    periodos = await repository.getPeriodos();
    loading = false;
    notifyListeners();
  }

  Future<void> loadPeriodoActivo() async {
    periodoActivo = await repository.getPeriodoActivo();
    notifyListeners();
  }

  Future<bool> createPeriodo({
    required String nombre,
    required String fechaInicio,
    required String fechaFin,
    bool activo = false,
  }) async {
    loading = true;
    notifyListeners();

    final result = await repository.createPeriodo(
      nombre: nombre,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      activo: activo,
    );

    loading = false;
    if (result != null) {
      await loadPeriodos();
      if (activo) periodoActivo = result;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> activarPeriodo(int id) async {
    loading = true;
    notifyListeners();

    final ok = await repository.activarPeriodo(id);

    if (ok) {
      await loadPeriodos();
      await loadPeriodoActivo();
    }

    loading = false;
    notifyListeners();
    return ok;
  }

  Future<bool> deletePeriodo(int id) async {
    loading = true;
    notifyListeners();

    final ok = await repository.deletePeriodo(id);
    if (ok) await loadPeriodos();

    loading = false;
    notifyListeners();
    return ok;
  }
}