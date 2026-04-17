import 'package:dio/dio.dart';
import '../models/estudiante.dart';

class EstudianteRepository {
  final Dio _dio;
  EstudianteRepository(this._dio);

  Future<List<Estudiante>> getEstudiantes() async {
    try {
      final response = await _dio.get('/estudiantes');
      return (response.data as List)
          .map((e) => Estudiante.fromJson(e))
          .toList();
    } catch (e) {
      if (e is DioException) print("ERROR GET ESTUDIANTES: ${e.response?.data}");
      return [];
    }
  }

  Future<bool> createEstudiante({
    required String name,
    required String email,
    required String password,
    required String codigo,
  }) async {
    try {
      await _dio.post('/estudiantes', data: {
        'name': name,
        'email': email,
        'password': password,
        'codigo_estudiante': codigo,
      });
      return true;
    } catch (e) {
      if (e is DioException) print("ERROR CREATE ESTUDIANTE: ${e.response?.data}");
      return false;
    }
  }

  Future<bool> deleteEstudiante(int id) async {
    try {
      await _dio.delete('/estudiantes/$id');
      return true;
    } catch (e) {
      if (e is DioException) print("ERROR DELETE ESTUDIANTE: ${e.response?.data}");
      return false;
    }
  }
}