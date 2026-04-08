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
}