import 'package:dio/dio.dart';
import '../models/asignacion.dart';

class AsignacionRepository {
  final Dio _dio;
  AsignacionRepository(this._dio);

  Future<Map<String, List<Asignacion>>> getHorario(int profesorId) async {
    try {
      final response = await _dio.get('/profesores/$profesorId/horario');
      final Map<String, dynamic> raw = response.data['horario'] ?? {};

      return raw.map((dia, lista) {
        final items = (lista as List)
            .map((e) => Asignacion.fromJson(e))
            .toList();
        return MapEntry(dia, items);
      });
    } catch (e) {
      if (e is DioException) print("ERROR HORARIO: ${e.response?.data}");
      return {};
    }
  }

  // ⚠️ Confirma el endpoint con tu backender
  Future<String?> crearAsignacion({
  required int profesorId,
  required int subjectId,
  required int cursoId,
  required int paraleloId,
  required String dia,
  required String horaInicio,
  required String horaFin,
}) async {
  try {
    await _dio.post('/asignaciones', data: {
      'profesor_id': profesorId,
      'subject_id': subjectId,
      'curso_id': cursoId,
      'paralelo_id': paraleloId,
      'dia': dia,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
    });

    return null; // ✅ éxito
  } catch (e) {
    if (e is DioException) {
      final data = e.response?.data;

      if (data != null && data['message'] != null) {
        return data['message'];
      }

      if (data != null && data['errors'] != null) {
        return data['errors'].toString();
      }
    }
    return "Error desconocido";
  }
}
}