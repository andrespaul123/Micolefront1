import 'package:dio/dio.dart';
import '../models/profesor.dart';

class ProfesorRepository {
  final Dio _dio;

  ProfesorRepository(this._dio);

  // 🔥 LISTAR
  Future<List<Profesor>> getProfesores() async {
    try {
      final response = await _dio.get('/profesores');

      return (response.data as List)
          .map((e) => Profesor.fromJson(e))
          .toList();
    } catch (e) {
      if (e is DioException) {
        print("ERROR PROFESORES: ${e.response?.data}");
      }
      return [];
    }
  }

  // 🔥 CREAR
  Future<bool> createProfesor({
    required String name,
    required String email,
    required String password,
    required String codigo,
    String? especialidad,
  }) async {
    try {
      await _dio.post(
        '/profesores',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'codigo_profesor': codigo,
          'especialidad': especialidad,
        },
      );

      return true;
    } catch (e) {
      if (e is DioException) {
        print("ERROR CREATE PROFESOR: ${e.response?.data}");
      }
      return false;
    }
  }

  Future<bool> asignarMateria({
  required int profesorId,
  required int subjectId,
}) async {
  try {
    await _dio.post(
      '/profesores/asignar-materia',
      data: {
        'profesor_id': profesorId,
        'subject_id': subjectId,
      },
    );

    return true;
  } catch (e) {
    if (e is DioException) {
      print("ERROR ASIGNAR: ${e.response?.data}");
    }
    return false;
  }
}
}