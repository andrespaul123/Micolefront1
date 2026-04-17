import 'package:dio/dio.dart';
import '../models/padre_familia.dart';

class PadreFamiliaRepository {
  final Dio _dio;
  PadreFamiliaRepository(this._dio);

  Future<List<PadreFamilia>> getPadres() async {
    try {
      final response = await _dio.get('/padre-familias');
      return (response.data as List)
          .map((e) => PadreFamilia.fromJson(e))
          .toList();
    } catch (e) {
      if (e is DioException) print("ERROR GET PADRES: ${e.response?.data}");
      return [];
    }
  }

  Future<bool> createPadre({
    required String name,
    required String email,
    required String password,
    String? telefono,
    String? ocupacion,
  }) async {
    try {
      await _dio.post('/padre-familias', data: {
        'name': name,
        'email': email,
        'password': password,
        'telefono': telefono,
        'ocupacion': ocupacion,
      });
      return true;
    } catch (e) {
      if (e is DioException) print("ERROR CREATE PADRE: ${e.response?.data}");
      return false;
    }
  }

  Future<bool> deletePadre(int id) async {
    try {
      await _dio.delete('/padre-familias/$id');
      return true;
    } catch (e) {
      if (e is DioException) print("ERROR DELETE PADRE: ${e.response?.data}");
      return false;
    }
  }
}