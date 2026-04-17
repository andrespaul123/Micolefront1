import 'package:dio/dio.dart';
import '../models/academic_period.dart';

class AcademicPeriodRepository {
  final Dio _dio;
  AcademicPeriodRepository(this._dio);

  Future<List<AcademicPeriod>> getPeriodos() async {
    try {
      final response = await _dio.get('/periodos');
      return (response.data as List)
          .map((e) => AcademicPeriod.fromJson(e))
          .toList();
    } catch (e) {
      if (e is DioException) print("ERROR GET PERIODOS: ${e.response?.data}");
      return [];
    }
  }

  Future<AcademicPeriod?> getPeriodoActivo() async {
    try {
      final response = await _dio.get('/periodos/activo');
      return AcademicPeriod.fromJson(response.data);
    } catch (e) {
      if (e is DioException) print("ERROR PERIODO ACTIVO: ${e.response?.data}");
      return null;
    }
  }

  Future<AcademicPeriod?> createPeriodo({
    required String nombre,
    required String fechaInicio,
    required String fechaFin,
    bool activo = false,
  }) async {
    try {
      final response = await _dio.post('/periodos', data: {
        'nombre': nombre,
        'fecha_inicio': fechaInicio,
        'fecha_fin': fechaFin,
        'activo': activo,
      });
      return AcademicPeriod.fromJson(response.data);
    } catch (e) {
      if (e is DioException) print("ERROR CREATE PERIODO: ${e.response?.data}");
      return null;
    }
  }

  Future<bool> activarPeriodo(int id) async {
    try {
      await _dio.patch('/periodos/$id/activar');
      return true;
    } catch (e) {
      if (e is DioException) print("ERROR ACTIVAR PERIODO: ${e.response?.data}");
      return false;
    }
  }

  Future<bool> deletePeriodo(int id) async {
    try {
      await _dio.delete('/periodos/$id');
      return true;
    } catch (e) {
      if (e is DioException) print("ERROR DELETE PERIODO: ${e.response?.data}");
      return false;
    }
  }
}