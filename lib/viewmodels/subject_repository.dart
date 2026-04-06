import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../repository/subject_repository.dart';

class SubjectViewModel extends ChangeNotifier {
  final SubjectRepository repository;

  bool loading = false;
  List<Subject> subjects = [];

  SubjectViewModel({required this.repository});

  // CREAR
  Future<bool> createSubject(String name) async {
    loading = true;
    notifyListeners();

    final subject = await repository.createSubject(name);

    loading = false;

    if (subject != null) {
      subjects.add(subject);
      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
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