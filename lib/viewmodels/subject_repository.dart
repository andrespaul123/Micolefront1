import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../repository/subject_repository.dart';

class SubjectViewModel extends ChangeNotifier {
  final SubjectRepository repository;

  bool loading = false;
  List<Subject> subjects = [];

  String? error;

  SubjectViewModel({required this.repository});

<<<<<<< Updated upstream
  // CREAR
  Future<bool> createSubject(String name) async {
    loading = true;
    notifyListeners();

    final subject = await repository.createSubject(name);

    loading = false;

    if (subject != null) {
      subjects.add(subject);
=======
  Future<bool> createSubject(String name) async {
    if (creating) return false;

    creating = true;
    error = null;
    notifyListeners();

    try {
      await repository.createSubject(name);

      await loadSubjects();
      return true;

    } on DioException catch (e) {
      final data = e.response?.data;

      error =
          data?['errors']?['name']?[0] ??
          data?['message'] ??
          'Error inesperado';

      notifyListeners(); // 🔥 CLAVE
      return false;

    } finally {
      creating = false;
>>>>>>> Stashed changes
      notifyListeners();
      return true;
    }

    notifyListeners();
    return false;
  }

<<<<<<< Updated upstream
  // LISTAR
=======
>>>>>>> Stashed changes
  Future<void> loadSubjects() async {
    loading = true;
    notifyListeners();

    try {
      subjects = await repository.getSubjects();
    } catch (_) {
      subjects = [];
    }

    loading = false;
    notifyListeners();
  }
}