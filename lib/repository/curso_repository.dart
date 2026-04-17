import 'package:dio/dio.dart';
import '../models/curso.dart';

class CursoRepository {
  final Dio _dio;

  CursoRepository(this._dio);

  Future<List<Curso>> getCursos(int periodoId) async {
    try {
      final response = await _dio.get('/periodos/$periodoId/cursos');
      return (response.data as List)
          .map((e) => Curso.fromJson(e))
          .toList();
    } catch (e) {
      if (e is DioException) {print("ERROR GET CURSOS: ${e.response?.data}");
      }
      return [];
    }
  }

  Future<bool> createCurso({
    required int periodoId,
    required String nombre,
    required String nivel,
    String? descripcion,
  }) async {
    try {
      await _dio.post(
        '/periodos/$periodoId/cursos',
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

  Future<bool>deleteCurso(int periodoId, int id) async {
    try {
      await _dio.delete('/periodos/$periodoId/cursos/$id');
      return true;
    } catch (e) {
      if (e is DioException) {
        print("ERROR DELETE CURSO: ${e.response?.data}");
      }
      return false;
    }
  }
}