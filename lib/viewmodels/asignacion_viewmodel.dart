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

  loading = false;
  notifyListeners();

  return error;
}
}