import 'package:flutter/material.dart';
import '../models/paralelo.dart';
import '../repository/paralelo_repository.dart';

class ParaleloViewModel extends ChangeNotifier {
  final ParaleloRepository repository;

  bool loading = false;
  List<Paralelo> paralelos = [];

  ParaleloViewModel({required this.repository});

  Future<void> loadParalelos() async {
    loading = true;
    notifyListeners();

    paralelos = await repository.getParalelos();

    loading = false;
    notifyListeners();
  }

  Future<bool> createParalelo({
    required int cursoId,
    required String nombre,
    String? turno,
    int? capacidad,
  }) async {
    loading = true;
    notifyListeners();

    final success = await repository.createParalelo(
      cursoId: cursoId,
      nombre: nombre,
      turno: turno,
      capacidad: capacidad,
    );

    loading = false;

    if (success) {
      await loadParalelos();
      return true;
    }

    notifyListeners();
    return false;
  }


  Future<bool> deleteParalelo(int id) async {
    loading = true;
    notifyListeners();

    final success = await repository.deleteParalelo(id);

    if (success) await loadParalelos();

    loading = false;
    notifyListeners();
    return success;
  }
<<<<<<< Updated upstream
=======

 /*   Future<void> loadParalelosByCurso(int periodoId, int cursoId) async {
    
  loading = true;
  notifyListeners();

  paralelos = await repository.getParalelosByCurso(periodoId, cursoId);

  loading = false;
  notifyListeners();
}  */
/* Future<void> loadParalelosByCurso(int periodoId, int cursoId) async {
    _periodoId  = periodoId;
    _cursoId    = cursoId;
    loading     = true;
    initialized = false;
    notifyListeners();

    paralelos   = await repository.getParalelosByCurso(periodoId, cursoId);
    loading     = false;
    initialized = true;
    notifyListeners();
  }

  Future<void> reload() async {
    if (_periodoId == null || _cursoId == null) return;
    await loadParalelosByCurso(_periodoId!, _cursoId!);
  } */Future<void> loadParalelosByCurso(int periodoId, int cursoId) async {
  _periodoId = periodoId;   // 👈 GUARDAR
  _cursoId = cursoId;       // 👈 GUARDAR

  loading = true;
  notifyListeners();

  paralelos = await repository.getParalelosByCurso(periodoId, cursoId);

  loading = false;
  notifyListeners();
}
Future<void> reload() async {
  if (_periodoId == null || _cursoId == null) return;

  await loadParalelosByCurso(_periodoId!, _cursoId!);
}

>>>>>>> Stashed changes
}