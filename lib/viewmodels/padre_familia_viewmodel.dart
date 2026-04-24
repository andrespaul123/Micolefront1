import 'package:flutter/material.dart';
import '../models/padre_familia.dart';
import '../repository/padre_familia_repository.dart';

class PadreFamiliaViewModel extends ChangeNotifier {
  final PadreFamiliaRepository repository;
  PadreFamiliaViewModel({required this.repository});

  bool loading = false;
  bool creating = false;
  List<PadreFamilia> padres = [];

  Future<void> loadPadres() async {
    loading = true;
    notifyListeners();
    padres = await repository.getPadres();
    loading = false;
    notifyListeners();
  }

  Future<bool> createPadre({
    required String name,
    required String email,
    required String password,
    String? telefono,
    String? ocupacion,
  }) async {
    if(creating) return false;

    creating = true;
    notifyListeners();
    try {
      final success = await repository.createPadre(
        name: name, email: email, password: password,
        telefono: telefono, ocupacion: ocupacion,
      );
      if (success) {
        await loadPadres();
      }
      return success;
    } finally {
      creating = false;
      notifyListeners();
    }
  }

  Future<bool> deletePadre(int id) async {
    loading = true;
    notifyListeners();
    final success = await repository.deletePadre(id);
    if (success) await loadPadres();
    loading = false;
    notifyListeners();
    return success;
  }
}