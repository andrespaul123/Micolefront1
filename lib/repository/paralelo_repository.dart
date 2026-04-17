import 'package:dio/dio.dart';
import '../models/paralelo.dart';

class ParaleloRepository {
  final Dio _dio;

  ParaleloRepository(this._dio);

  Future<List<Paralelo>> getParalelos() async {
    try {
      final response = await _dio.get('/paralelos');
      return (response.data as List)
          .map((e) => Paralelo.fromJson(e))
          .toList();
    } catch (e) {
      if (e is DioException) {
        print("ERROR GET PARALELOS: ${e.response?.data}");
      }
      return [];
    }
  }

  /* Future<bool> createParalelo({
    required int cursoId,
    required String nombre,
    String? turno,
    int? capacidad,
  }) async {
    try {
      await _dio.post(
        '/paralelos',
        data: {
          'curso_id': cursoId,
          'nombre': nombre,
          'turno': turno,
          'capacidad': capacidad,
        },
      );
  
      return true; 
    } catch (e) {
      if (e is DioException) {
        print("ERROR CREATE PARALELO: ${e.response?.data}");
      }
      return false;
    }
  } */
 Future<Paralelo?> createParalelo({
  required int cursoId,
  required String nombre,
  String? turno,
  int? capacidad,
}) async {
  try {
    final response = await _dio.post( 
      '/paralelos',
      data: {
        'curso_id': cursoId,
        'nombre': nombre,
        'turno': turno,
        'capacidad': capacidad,
      },
    );

    return Paralelo.fromJson(response.data); 
  } catch (e) {
    if (e is DioException) {
      print("ERROR CREATE PARALELO: ${e.response?.data}");
    }
    return null;
  }
}

  Future<bool> deleteParalelo(int id) async {
    try {
      await _dio.delete('/paralelos/$id');
      return true;
    } catch (e) {
      if (e is DioException) {
        print("ERROR DELETE PARALELO: ${e.response?.data}");
      }
      return false;
    }
  }
 Future<List<Paralelo>> getParalelosByCurso(int periodoId, int cursoId) async {
  try {
    final response = await _dio.get(
      '/periodos/$periodoId/cursos/$cursoId/paralelos',
    );

    final List data = response.data['data']; // 🔥 IMPORTANTE

    return data.map((e) => Paralelo.fromJson(e)).toList();
  } catch (e) {
    if (e is DioException) {
      print("ERROR GET PARALELOS CURSO: ${e.response?.data}");
    }
    return [];
  }
}
}