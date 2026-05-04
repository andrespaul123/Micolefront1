import 'package:flutter/material.dart';
import '../models/asignacion.dart';
import '../repository/asignacion_repository.dart';

class AsignacionViewModel extends ChangeNotifier {
  final AsignacionRepository repository;
  AsignacionViewModel({required this.repository});

  bool loading = false;
  Map<String, List<Asignacion>> horario = {};
  
  Future<void> loadHorario(int profesorId) async {
    loading = true;
    notifyListeners();

    horario = await repository.getHorario(profesorId);

    loading = false;
    notifyListeners();
  }

  Future<String?> crearAsignacion({
  required int profesorId,
  required int subjectId,
  required int cursoId,
  required int paraleloId,
  required String dia,
  required String horaInicio,
  required String horaFin,
}) async {
  loading = true;
  notifyListeners();

  final error = await repository.crearAsignacion(
    profesorId: profesorId,
    subjectId: subjectId,
    cursoId: cursoId,
    paraleloId: paraleloId,
    dia: dia,
    horaInicio: horaInicio,
    horaFin: horaFin,
  );

<<<<<<< Updated upstream
  loading = false;
  notifyListeners();

  return error;
=======
  loadingCurso = false;
  notifyListeners();
}
} */
/* Future<void> loadHorarioCurso({
  required int cursoId,
  required int paraleloId,
}) async {
  loadingCurso = true;
  notifyListeners();

  // 🔥 ASEGURAR PERIODO
  if (periodoActivo == null) {
    await loadPeriodo();
  }

  if (periodoActivo == null) {
    horarioCurso = {};
    loadingCurso = false;
    notifyListeners();
    return;
  }

  horarioCurso = await repository.getHorarioCurso(
    periodoId:  periodoActivo!.id!,
    cursoId:    cursoId,
    paraleloId: paraleloId,
  );

  loadingCurso = false;
  notifyListeners();
} */
Future<void> loadHorarioCurso({
  required int cursoId,
  required int paraleloId,
}) async {
  loadingCurso = true;
  notifyListeners();

  // 🔥 asegurar periodo
  if (periodoActivo == null) {
    await loadPeriodo();
  }

  // 🔥 si no hay periodo → limpiar y salir
  if (periodoActivo == null) {
    horarioCurso = {};
    loadingCurso = false;
    notifyListeners();
    return;
  }

  horarioCurso = await repository.getHorarioCurso(
    periodoId: periodoActivo!.id!,
    cursoId: cursoId,
    paraleloId: paraleloId,
  );

  loadingCurso = false;
  notifyListeners();
>>>>>>> Stashed changes
}
}