import 'package:dio/dio.dart';
import '../models/curso.dart';

class CursoRepository {
  final Dio _dio;

  CursoRepository(this._dio);

  Future<List<Curso>> getCursos() async {
    try {
      final response = await _dio.get('/cursos');
      return (response.data as List)
          .map((e) => Curso.fromJson(e))
          .toList();
    } catch (e) {
      if (e is DioException) {
        print("ERROR GET CURSOS: ${e.response?.data}");
      }
      return [];
    }
  }

  Future<bool> createCurso({
    required String nombre,
    required String nivel,
    String? descripcion,
  }) async {
    try {
      await _dio.post(
        '/cursos',
        data: {
          'nombre': nombre,
          'nivel': nivel,
          'descripcion': descripcion,
        },
      );
      return true;
    } catch (e) {
      if (e is DioException) {
        print("ERROR CREATE CURSO: ${e.response?.data}");
      }
      return false;
    }
  }

  Future<bool>deleteCurso(int id) async {
    try {
      await _dio.delete('/cursos/$id');
      return true;
    } catch (e) {
      if (e is DioException) {
        print("ERROR DELETE CURSO: ${e.response?.data}");
      }
      return false;
    }
  }
}