import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../repository/subject_repository.dart';

class SubjectViewModel extends ChangeNotifier {
  final SubjectRepository repository;

  bool loading = false;
  bool creating = false;
  List<Subject> subjects = [];

  SubjectViewModel({required this.repository});

  // CREAR
  // 🔥 CREAR
  Future<bool> createSubject(String name) async {
    if (creating) return false; // evita doble click

    creating = true;
    notifyListeners();

    try {
      final subject = await repository.createSubject(name);

      if (subject != null) {
        await loadSubjects(); // 🔥 no recarga toda la lista
        return true;
      }

      return false;
    } finally {
      creating = false;
      notifyListeners();
    }
  }
  // LISTAR
  Future<void> loadSubjects() async {
    loading = true;
    notifyListeners();

    subjects = await repository.getSubjects();

    loading = false;
    notifyListeners();
  }
}